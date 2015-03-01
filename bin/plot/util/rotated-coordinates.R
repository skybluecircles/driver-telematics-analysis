#!/usr/bin/Rscript

source("bin/util/driver-trip-args.R")
source("bin/util/data.R")

rotated <- driver_trip_csv( driver_id, trip_id, "coordinates-rotated" )

x <- rotated[[1]]
y <- rotated[[2]]

xmin <- min(x)
xmax <- max(x)
ymin <- min(y)
ymax <- max(y)

lim <- c( min( xmin, ymin ), max( xmax, ymax ) )

out <- driver_trip_file( driver_id, trip_id, "rotated-coordinates.svg" )
svg(out)

plot(  x, y, pch = 16, cex = 0.10, xlab = "", ylab = "", xlim = lim, ylim = lim )

lines(  x, y, lwd = 3, col = "blue" )

title <- paste( driver_id, "-", trip_id, " Rotated Coordinates", sep = "" )
title( main = title )

dev.off()
