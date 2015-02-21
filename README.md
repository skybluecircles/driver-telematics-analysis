# driver-telematics-analysis

After cloning this repo, download the DTA data from the Kaggle website:

http://www.kaggle.com/c/axa-driver-telematics-analysis

Then run the commands below.

```
$ bin/environment
$ bin/setup-data
$ bin/util/install-dependencies
$ bin/compile
$ prove t/integration
```

To begin visualizing the data:

```
$ bin/plot/coordinates
$ morbo web-app.pl
```

And visit

#### http://127.0.0.1:3000/
