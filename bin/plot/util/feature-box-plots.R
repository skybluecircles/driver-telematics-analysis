#!/usr/bin/Rscript

source("bin/util/data.R")
source("bin/util/driver-trip-args.R")

features.tagged <- driver_csv( driver_id, "features.csv" )
features        <- subset( features.tagged, select = -c( driver_id, trip_id ) )

out <- driver_file( driver_id, "box-plots.svg" )
svg(out)

title <- paste( "Boxplots for Driver", driver_id, "Features", sep = " " )
boxplot( features, xlab = "", main = title, las = 2 )

dev.off()
