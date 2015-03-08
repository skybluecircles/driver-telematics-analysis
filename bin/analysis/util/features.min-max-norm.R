#!/usr/bin/Rscript

source("bin/util/data.R")
source("bin/util/driver-trip-args.R")

features <- driver_csv( driver_id, "features.csv" )

mm.norm <- function(x) {
    return ((x-min(x))/(max(x)-min(x)))
}
features.mm.norm <- lapply( features[-c(1,2)], mm.norm )

features.recombined <- cbind( features[1:2], features.mm.norm )

write.driver.csv <- function( data, file, driver_id ) {
    file <- driver_file( driver_id, file )
    write.csv( data, file = file, row.names = FALSE )
}

write.driver.csv(
    features.recombined,
    "features.min-max-norm.csv",
    driver_id
)
