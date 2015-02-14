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
You might need to `bin/install-cpan-dependencies`

`j` and `l` loop through the images

* http://127.0.0.1:3000/driver/1/trip/1/orig-rotated-coordinates
* http://127.0.0.1:3000/driver/1/trip/1/rotated-coordinates
* http://127.0.0.1:3000/driver/1/trip/1/rotated-coordinates-with-calipers
* http://127.0.0.1:3000/driver/1/trip/1/rotated-coordinates-just-calipers
