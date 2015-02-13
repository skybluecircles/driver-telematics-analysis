# driver-telematics-analysis

After cloning this repo, download the DTA data from the Kaggle website:

http://www.kaggle.com/c/axa-driver-telematics-analysis

Then run `bin/setup` - this will initialize the filesystem.

Then run `bin/batch/morphology` - this will rotate the coordinates and reduce them to just a few points.

```
You might want to manually change each individual script to just run on driver 1
                    (otherwise it might take a while)                           
      I will change this so that it can be set when the script is invoked       
```

Then run some plots in `bin/plot`

Start the webserver with `morbo dta-appl.pl`

Make sure `public` is linked to DTA_DATA/driver:

```
$ ls -l public/
total 8
lrwxr-xr-x  1 candela  wheel   15 Feb  9 09:42 driver -> ../data/driver/
```

`j` and `l` loop through the images

Try:

http://127.0.0.1:3000/driver/1/trip/1/orig-rotated-coordinates
http://127.0.0.1:3000/driver/1/trip/1/rotated-coordinates
http://127.0.0.1:3000/driver/1/trip/1/rotated-coordinates-with-calipers
http://127.0.0.1:3000/driver/1/trip/1/rotated-coordinates-just-calipers

