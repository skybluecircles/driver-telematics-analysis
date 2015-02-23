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
$ bin/compile
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
morbo web-app.pl
```

And [visualize](http://127.0.0.1/driver/1/pin-wheel) what you've done.

* 'j' moves to the previous driver
* 'l' moves to the next driver
