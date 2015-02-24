#!/usr/bin/Rscript

source("bin/util/driver-trip-args.R")
source("bin/util/data.R")

original <- driver_trip_csv( driver_id, trip_id, "coordinates" )
rotated  <- driver_trip_csv( driver_id, trip_id, "coordinates-rotated" )

combined <- data.frame( x = c( original[[1]], rotated[[1]] ), y = c( original[[2]], rotated[[2]] ) )

x_max <- max( combined$x )
x_min <- min( combined$x )
y_max <- max( combined$y )
y_min <- min( combined$y )

min <- min( x_min, y_min )
max <- max( x_max, y_max )

lim <- c( min, max ) # want axes to have the same scale

out <- driver_trip_file( driver_id, trip_id, "orig-rotated-coordinates.svg" )
svg(out)

plot(  original[[1]], original[[2]], pch = 16, cex = 0.10, xlab = "", ylab = "", xlim = lim, ylim = lim )

lines( original[[1]], original[[2]], lwd = 3 )
lines(  rotated[[1]],  rotated[[2]], lwd = 3, col = "blue" )

title <- paste( driver_id, "-", trip_id, " Orig + Rotated Coordinates", sep = "" )
title( main = title )

dev.off()
