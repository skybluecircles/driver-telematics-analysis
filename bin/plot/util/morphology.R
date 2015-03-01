#!/usr/bin/Rscript

source("bin/util/driver-trip-args.R")
source("bin/util/data.R")

# Get data

morphology <- driver_trip_csv( driver_id, trip_id, "morphology-points" )

x_max <- max( morphology[3,1] )
x_min <- min( morphology[1,1] )
y_max <- max( morphology[2,2] )
y_min <- 0

min <- min( x_min, y_min )
max <- max( x_max, y_max )

height <- abs(min) + max
min <- min - height * 0.064

lim <- c( min, max ) # want axes to have the same scale

# The outer boundarry

x <- c( 0, morphology[[1]], 0 )
y <- c( 0, morphology[[2]], 0 )

out <- driver_trip_file( driver_id, trip_id, "morphology.svg" )
svg(out)

plot_morphology <- function() {

    plot ( x, y, pch = 16, cex = 0.10, xlab = "", ylab = "", xlim=lim, ylim=lim )

    # Solid, thin vertical line

    lines( c( 0, 0 ), morphology[2,], col = "grey" )

    # Dashed lines from y axis to left / right-most points

    lines( c( 0, morphology[1,1] ), c( morphology[1,2], morphology[1,2] ), col = "grey", lty = 2 )
    lines( c( 0, morphology[3,1] ), c( morphology[3,2], morphology[3,2] ), col = "grey", lty = 2 )

    # Draw the boundary

    lines( x, y, lwd = 2 )
}

plot_morphology()

title <- paste( driver_id, "-", trip_id, " Morphology", sep = "" )
title( main = title)

dev.off()

# Redraw the plot with the trip's coordinates included

coordinates_rotated <- driver_trip_csv( driver_id, trip_id, "coordinates-rotated" )

out <- driver_trip_file( driver_id, trip_id, "morphology-with-coordinates.svg" )
svg(out)

plot_morphology()

lines( coordinates_rotated[[1]], coordinates_rotated[[2]], col = "blue", lwd = 2.76 )

title <- paste( driver_id, "-", trip_id, " Morphology with Coordinates" )
title( main = title )

dev.off()
