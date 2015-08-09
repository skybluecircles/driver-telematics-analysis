# driver-telematics-analysis

## Download data

After cloning this repo, download the DTA data from the Kaggle website:

http://www.kaggle.com/c/axa-driver-telematics-analysis

You'll need to create a Kaggle account if you don't already have one.

Note that it's a 1.44 GB file and you'll need ~10-15 GB free to work with the data.

## Initial setup

Then run the commands below.

```
$ bin/setup/environment    # quick
$ bin/setup/data           # 1-3 hours
$ bin/setup/dependencies   # varies

# prove t/integration/setup/*
```

If you get no errors, your environment should be sane.

## Visualization

Now, plot a few driver's trips:

```
$ bin/plot/pin-wheel 1
$ bin/plot/pin-wheel 2
$ bin/plot/pin-wheel 3612
```

The arg is actually a glob, so you could also pass:

```
$ bin/plot/pin-wheel '1??' # any driver matching 1??
$ bin/plot/pin-wheel '*'   # all drivers
```

Now, you can start the web-app.

```
$ bin/web-app-up    # may need to: perl bin/web-app-up
```

And [visualize](http://127.0.0.1:3000/driver/1/pin-wheel) what you've done.

* 'j' moves to the previous driver
* 'l' moves to the next driver

*You'll need to have created the plot for any driver you want to look at.*

## Working with the data

Now you can begin working with the data.

### Rotation

To rotate the coordinates for each trip such that the furthest point from the origin faces due north:

```
$ bin/compile/rotate-coordinates
$ bin/rotate 1
```

This normalizes the direction of a driver's trips and helps compare the path of one trip to another.

Now, plot what you've done:

```
$ bin/plot/orig-rotated-coordinates 1
$ bin/plot/rotated-coordinates 1
```

And visualize it:
* [orig-rotated-coorindates](http://127.0.0.1:3000/driver/1/trip/1/orig-rotated-coordinates)
* [rotated-coordinates](http://127.0.0.1:3000/driver/1/trip/1/rotated-coordinates)

*This also calculated the distance between the final destination and the origin*

### Morphology

Now that you've rotated the coordinates, you can reduce each trip to 4 points.

```
$ bin/compile/morphology
$ bin/morphology 1
```

And plot what you've done:

```
$ bin/plot/morphology
```

And visualize it:

* [morphology](http://127.0.0.1:3000/driver/1/trip/1/morphology)
* [morphology-with-coordinates](http://127.0.0.1:3000/driver/1/trip/1/morphology-with-coordinates)

"*k*" toggles between the two

*Note: you also calculated the "width" and "max_distance_from_origin" for each trip.*


### Distances / Acceleration / Duration

We can derive the distance between each point and how much more (or less) the driver traveled between one interval and the next:

```
$ bin/compile/distances
$ bin/distances 1
```

This will also give us the total distance and duration for each trip along with the acceleration between each interval and also the average velocity.

However, the car's being stationary doesn't seem to carry a lot of information. Let's filter out repeated coordinates.

```
$ bin/coordinates-without-repeats 1
```

We'll use this in a minute.

### Rotation between intervals

It would be helpful to know how much the driver turns as they move from point to point - kind of like acceleration but for the amount of rotation.

The filtering we just did will be helpful here as rotation doesn't really mean anything if the driver isn't moving.

```
$ bin/compile/interval-rotations
$ bin/interval-rotations 1
```

*We also just calculated the absolute amount of rotation for each trip*

## Features

### Generation

Let's generate some features:

```
$ bin/features 1
```

This will amalgamate the features for each of a given driver's trips into single csv.

```
$ head $DTA_DATA/driver/1/features.csv
```

### CSV Columns

<dl>
  <dt>distance</dt>
  <dd>The total distance of the trip.</dd>

  <dt>duration</dt>
  <dd>How long the trip took.</dd>

  <dt>average velocity</dt>
  <dd>distance / duration</dd>

  <dt>absolute rotation</dt>
  <dd>The absolute amount of radians the driver turned during the trip.</dd>

  <dt>max distance from origin</dt>
  <dd>The distance between the origin and the furthest from the point from the origin.</dd>

  <dt>final distance from origin</dt>
  <dd>The distance between the final point and the origin.</dd>

  <dt>width</dt>
  <dd>How "wide" is the trip?<br><br>Take the line from the origin to the furthest point from the origin. Then, for each point, calculate the orthogonal distance between the "max distance" line and the point. Then take the difference between the "right most" point and the "left most" point.</dd>
</dl>

### Convenience Script

There's also now a convenience script to generate all of the commands we've gone over, from rotation to features (except for the plotting).

```
$ bin/all-driver-data 1
```

Again, it takes a glob. So, you could do:

```
$ bin/all-driver-data '*' # might take a while
```

## Analysis

### "Shape" of Features

As we begin to analyze our features, it would be good to get a sense of their shape. For a given driver, for each features, let's look at the distribution of the values.

```
$ bin/plot/feature-box-plots 1
```

[box-plots](http://127.0.0.1:3000/driver/1/box-plots)

Clearly the features have vastly difference scales.

Either we use a non-parametric algorithm - or we scale them.

We'll start by scaling them.

### Scaling Features

In Machine Learning with R, Brett Lantz shows how scale a range of values from their own min / max to 0 and 1. [\[1\]](#footnote-1)

It's less sophisticated than other methods, but that isn't necessarily a strike against it - sometimes simpler is better.

So, let's start here.

```
$ bin/analysis/features.min-max-norm 1
$ head $DTA_DATA/driver/1/features.min-max-norm.csv
```

As you can see the values are different, but, in some ways, it let's us compare the features more easily.

We can even replot our box-plots to see this more easily.

```
$ bin/plot/feature-box-plots.min-max-norm 1
```

[box-plots-min-max-norm](http://127.0.0.1:3000/driver/1/box-plots-min-max-norm)

"*k*" toggles between the scalings

### kmeans

Differentiating the trips is an unsupervised learning task as we have not been given any data with truth values.

So, one approach is to look for clusters.

We'll start with kmeans.

```
$ bin/analysis kmeans 1
$ cat data/driver/1/probs
```

After kmeans finds the clusters, we bluntly assign 1 to the 6-most populated clusters and 0 to the others.

There's definitely room for improvement :-)

## Making a Submission

If we run kmeans against all of the drivers, we can then amalgamate the results:

```
$ bin/analysis/amalgamate-probs
```

There will be a file in `$DTA_DATA` called probs with a timestamp after it.

```
$ ls $DTA_DATA
```

You can do a quick validity check on it.

```
$ perl bin/analysis/check-submission.pl /path/to/probs
```

It raises an expcetion if any line is malformed and outputs the % of trips for each prob.

## Footnotes

<a id="footnote-1"></a>[1] Lantz, Brett, *Machine Learning with R*, Birmingham: Packt Publishing, 2013, PDF e-book, pp 78-80
