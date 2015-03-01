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

*Note: you also calculated the "width" and "max_distance_from_origin" or each trip.*
