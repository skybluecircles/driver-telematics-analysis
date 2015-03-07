#!/usr/bin/Rscript

source("bin/util/driver-trip-args.R")
source("bin/util/data.R")

features <- driver_csv( driver_id, "features.csv" )

duration <- features$duration 
distance <- features$distance

out_file <- driver_file(
    driver_id,
    "distance-vs-duration.svg"
)
svg( out_file )

plot(
    duration,
    distance,
    xlab = "duration (seconds)",
    ylab = "distance (meters)",
    pch  = 16,
    cex  = 0.55,
    col  = "blue",
)

abline(lm(distance ~ duration), col = "dark grey" )

title <- paste(
    "distance vs. duration - driver ",
    driver_id,
    sep = ""
)
title( main = title )

dev.off()
