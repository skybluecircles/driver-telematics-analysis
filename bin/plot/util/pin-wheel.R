#!/usr/bin/Rscript

source("bin/util/driver-trip-args.R")
source("bin/util/data.R")

coordinates <- driver_trip_csv( driver_id, 1, "coordinates" )

# We need to know the mins and maxes for each axis across
# all of a driver's trips so that they all fit on the plot.

# Otherwise, the range of the axes would be set by the first
# trip we plot and the others might run off the page.

xmin <- min( coordinates[[1]] )
xmax <- max( coordinates[[1]] )
ymin <- min( coordinates[[2]] )
ymax <- max( coordinates[[2]] )

driver_trips <- list()
driver_trips[[1]] <- coordinates

for ( trip_id in 2:200 ) {
    coordinates <- driver_trip_csv( driver_id, trip_id, "coordinates" )

    trip_xmin <- min( coordinates[[1]] )
    trip_xmax <- max( coordinates[[1]] )
    trip_ymin <- min( coordinates[[2]] )
    trip_ymax <- max( coordinates[[2]] )

    if ( trip_xmin < xmin ) {
        xmin = trip_xmin
    }
    if ( trip_xmax > xmax ) {
        xmax = trip_xmax
    }
    if ( trip_ymin < ymin ) {
        ymin = trip_ymin
    }
    if ( trip_ymax > ymax ) {
        ymax = trip_ymax
    }

    driver_trips[[trip_id]] <- coordinates
}

out <- driver_file( driver_id, "pin-wheel.svg" )
svg( out )

coorindates <- driver_trips[[1]]

x <- coordinates[[1]]
y <- coordinates[[2]]

plot( x, y, pch=16, cex=0.10, xlab="", ylab="", xlim=c(xmin,xmax), ylim=c(ymin,ymax) )

lines( x, y, lwd = 3 )

for ( trip_id in 2:200 ) {
    coordinates <- driver_trips[[trip_id]]

    x <- coordinates[[1]]
    y <- coordinates[[2]]

    lines( x, y, lwd = 3 )
}

title <- paste( driver_id, " - Pin Wheel", sep = "" )
title( main = title )

dev.off()
