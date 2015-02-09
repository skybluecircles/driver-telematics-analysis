dta_data <- Sys.getenv( "DTA_DATA" )

if ( dta_data == "" ) {
    print ( "Please define the environment variable DTA_DATA" )
    stop()
}

driver_dir <- function( driver_id ) {
    paste( dta_data, "driver", driver_id, sep = "/" )
}

driver_file <- function ( driver_id, file ) {
    paste( driver_dir(driver_id), file, sep = '/' )
}

driver_trip_file <- function ( driver_id, trip_id,  file ) {
    trip_dir <- paste( driver_dir(driver_id), 'trip', trip_id, sep ='/' )
    paste( trip_dir, file, sep = '/' )
}

driver_trip_csv <- function( driver_id, trip_id, file ) {
    file <- driver_trip_file( driver_id, trip_id, file )
    read.csv( file, header = 0 )
}

driver_value <- function ( driver_id, file ) {
    file <- driver_file( driver_id, file )
    data <- read.delim( file, header = 0 )
    data[[1]]
}

driver_trip_value <- function ( driver_id, trip_id, file ) {
    file <- driver_trip_file( driver_id, trip_id, file )
    data <- read.delim( file, header = 0 )
    data[[1]]
}
