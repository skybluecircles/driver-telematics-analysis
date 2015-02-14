# driver-telematics-analysis

After cloning this repo, download the DTA data from the Kaggle website:

http://www.kaggle.com/c/axa-driver-telematics-analysis

Then run:

```
$ bin/setup             # initialize the filesystem (~3 hours)
$ bin/run-morphology    # rotate coordinates and reduce to 4 points
$ bin/plot-morphology   # visualize data
```

Start the webserver with `morbo dta-appl.pl`

#### Visit: http://127.0.0.1:3000

`j` and `l` loop through the images

You might need to `bin/install-cpan-dependencies`
