# driver-telematics-analysis

After cloning this repo, download the DTA data from the Kaggle website:

http://www.kaggle.com/c/axa-driver-telematics-analysis

Then run the commands below.

```
$ bin/environment
$ bin/setup-data
$ bin/util/install-dependencies
$ bin/compile
$ prove t/integration/*
```

If the integration tests pass, your environment should be sane.

Now you can begin working with the data:

```
$ bin/distances '*'
```

and [visualizing](http://127.0.0.1:3000/driver/1/distance-over-duration) it:

```
$ bin/plot/distance-over-duration '*'
$ morbo web-app.pl
```
