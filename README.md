# driver-telematics-analysis

## Download data

After cloning this repo, download the DTA data from the Kaggle website:

http://www.kaggle.com/c/axa-driver-telematics-analysis

## Initial setup

Then run the commands below.

```
$ bin/environment
$ bin/setup-data
$ bin/util/install-dependencies
$ prove t/integration/*
```

If the integration tests pass, your environment should be sane.

## Visualization

Now, plot a given driver's trips:

```
$ bin/plot/pin-wheel 1
```

The arg is actually a glob, so you could also pass:

```
$ bin/plot/pin-wheel '1??' # any driver matching 1??
$ bin/plot/pin-wheel '*'   # all drivers
```

Now, you can start the web-app.

```
$ bin/web-app-up    # may need to: $ perl -I./lib bin/web-app-up
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

* This also calculated the distance between the final destination and the origin *

### Morphology

Now that you've rotated the coordinates, you can reduce the trip to 4 points.

```
$ bin/compile/morphology
$ bin/morphology 1
```

And plot what you've done:

```
$ bin/plot/morphology
```

And visualize it:

* http://127.0.0.1:3000/driver/1/trip/1/morphology
* http://127.0.0.1:3000/driver/1/trip/1/morphology-with-coordinates

"*k*" toggles between the two

*Note: you also calculated the "width" and "max_distance_from_origin" for each trip.*


### Distances / Acceleration / Duration

We can derive the distance between each point and how much more (or less) the driver traveled between one interval and the next:

```
$ bin/compile/distance
$ bin/distance 1
```

This will also give us the total distance and duration for each trip along with the acceleration between each interval.

However, the car's being stationary doesn't seem to carry a lot of information. Let's filter out repeated coordinates.

```
$ bin/coordinates-without-repeats 1
```

We'll use this in a minute.

### Rotation between intervals

It would be helpful to know how much the driver turns as they move from point to point - kind of like acceleration but for the amount of rotation.

The filtering we just did will be helpful here as rotation doesn't really mean anything if the driver isn't moving.

```
$ bin/compile/interval-rotation
$ bin/interval-rotation 1
```

* We also just calculated the absolute amount of rotation for each trip *

## Generating Features

Let's generate some features:

```
$ bin/features 1
```

This will amalgamate the features for each of a given driver's trips into single files.

```
$ ls $DTA_DATA/driver/1
$ cat $DTA_DATA/driver/1/width     # just one example
```
