#!/usr/bin/Rscript

source("bin/util/driver-trip-args.R")
source("bin/util/data.R")

morphology <- driver_trip_csv( driver_id, trip_id, "morphology" )

# The outer boundarry
x <- c( 0, morphology[[1]], 0 )
y <- c( 0, morphology[[2]], 0 )

out <- driver_trip_file( driver_id, trip_id, "morphology.svg" )
svg(out)

plot ( x, y, pch = 16, cex = 0.10, xlab = "", ylab = "" )

# Solid, thin vertical line
lines( c( 0, 0 ), morphology[2,], col = "grey" )

# Dashed lines from y axis to left / right-most points
lines( c( 0, morphology[1,1] ), c( morphology[1,2], morphology[1,2] ), col = "grey", lty = 2 )
lines( c( 0, morphology[3,1] ), c( morphology[3,2], morphology[3,2] ), col = "grey", lty = 2 )

# Draw the boundary
lines( x, y, lwd = 2 )

title <- paste( driver_id, "-", trip_id, " Morphology", sep = "" )
title( main=title)

dev.off()
