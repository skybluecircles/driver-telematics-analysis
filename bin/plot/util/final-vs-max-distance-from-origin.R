#!/usr/bin/Rscript

source("bin/util/driver-trip-args.R")
source("bin/util/data.R")

features <- driver_csv(
    driver_id,
    "features.csv"
)

x <- features$max.distance.from.origin
y <- features$final.distance.from.origin

out <- driver_file(
    driver_id,
    "final-vs-max-distance-from-origin.svg"
)

svg(out)

plot(
    x, y,
    xlab = "max distance from origin (meters)",
    ylab = "final distance from origin (meters)",
    pch  = 16,
    cex  = 0.55,
    col  = "blue"
)

abline(lm( y ~ x ), col = "dark grey" )

title <- paste(
    "Final vs. Max Distance from Origin",
    " - Driver ",
    driver_id,
    sep = ""
)
title( main = title )

dev.off()
