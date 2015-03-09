#!/usr/bin/Rscript

library(stats)

source("bin/util/data.R")
source("bin/util/driver-trip-args.R")

features.tagged <- driver_csv( driver_id, "features.min-max-norm.csv" )
features        <- features.tagged[-c(1,2)]

# With kmeans we need to give the number of
# expected clusters in advance

# The general advice is sqrt( rows / 2 )

centers  <- sqrt( length(features[[1]]) / 2 ) 

clusters    <- kmeans( features, centers )
cluster.ids <- data.frame( cluster.id = clusters$cluster )

occurrences        <- as.data.frame(table(cluster.ids))
occurrences.sorted <- occurrences[with(occurrences, order(-Freq)), ] # http://stackoverflow.com/questions/1296646

# I eye-balled it and it looks like if you sort
# the number of times each cluster occurred,
# there's a break at 6/4

# I'm kind of assuming ~30% of the trips don't
# belong to the real driver

# Also, I've hard-coded the 1:6 below b/c I
# don't want to do this programmatically right
# now.

driver.clusters <- occurrences.sorted[c(1:6),1]

is.driver <- function( cluster.id ) {
    if( is.element( cluster.id, driver.clusters ) ) {
        return(1)
    } else {
        return(0)
    }
}

make.driver_trip <- function( driver_id, trip_id ) {
    return( paste( driver_id, trip_id, sep = "_" ) )
}

probs        <- sapply( cluster.ids$cluster.id, is.driver )
driver_trips <- mapply( make.driver_trip, features.tagged$driver_id, features.tagged$trip_id )

driver.output <- data.frame( driver_trip = driver_trips, prob = probs )

out.file <- driver_file( driver_id, "probs" )
write.table( driver.output, file = out.file, row.names = FALSE, col.names = FALSE, sep = ",", quote = FALSE )
