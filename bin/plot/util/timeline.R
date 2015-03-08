#!/usr/bin/Rscript

source("bin/util/driver-trip-args.R")
source("bin/util/data.R")

accelerations <- driver_trip_csv(
    driver_id,
    trip_id,
    "accelerations-without-repeats"
)
length <- length(accelerations[[1]])

intervals <- c(
    seq(
        from = 1,
        to = length,
        by = 1
    )
)
intervals <- intervals / 60

accelerations.pos <- subset( accelerations, V1 > 0 )
acc.max <- quantile( accelerations.pos[[1]], c( 0.995 ) )

accelerations.neg <- subset( accelerations, V1 < 0 )
acc.min <- quantile( accelerations.neg[[1]], c( 0.003 ) )

acc.lim <- c( acc.min, acc.max )

rotations <- driver_trip_csv(
    driver_id,
    trip_id,
    "interval-rotations"
)
lim.rot <- c( 3.25, -3.25 ) # pi / -pi + margin

out <- driver_trip_file(
    driver_id,
    trip_id,
    "timeline.svg"
)
svg( out, width = 200 )

par( oma=c(0,0,0,2) )

plot(
    intervals,
    accelerations[[1]],
    pch = 16,
    cex = 0.10,
    col = "blue",
    xlab = "time (minutes)",
    xaxt = "n",
    ylim = acc.lim,
    ylab = "accelerations m/s/s"
)


lines(
    intervals,
    accelerations[[1]],
    col = "blue",
    lwd = 2
)

lines(
    intervals,
    rotations[[1]],
    col = "brown",
    lwd = 2
)

abline( h=0, col = "dark grey" )

axis( 1, at = seq( from = 0, to = intervals[length(intervals)], by = 1 ) )
axis( 4, at = seq( from = -3.5, to = 3.5, by = 1 ) )
mtext( "rotation (radians)", side = 4, line = 3 )

title <- paste( driver_id, "-", trip_id, " Accelerations and Rotations vs. Time (without repeats)", sep = "" )
title( main = title )

legend( 'topleft', c("Acceleration", "Rotation" ), lty=c(1,1), lwd=c(2,2), col=c("blue","brown") )

dev.off()
