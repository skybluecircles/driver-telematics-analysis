#!/usr/bin/Rscript

source("bin/util/data.R")
source("bin/util/driver-trip-args.R")

features.tagged <- driver_csv( driver_id, "features.min-max-norm.csv" )
features        <- subset( features.tagged, select = -c( driver_id, trip_id ) )

out <- driver_file( driver_id, "box-plots-min-max-norm.svg" )
svg(out)

boxplot( features, xlab = "", las = 2 )

title <- paste( "Boxplots for Driver", driver_id, "Features               min/max normalized", sep = " " )
title( title, adj = 0 ) # left just so less change when user toggles between this and "no scaling"

dev.off()
