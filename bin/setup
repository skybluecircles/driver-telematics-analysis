#!/bin/bash

# GET LOCATION OF ZIP FILE

# Either from 1st param or from user input
# Don't want to do other work if this is not in place

zip_file=$1

if [ ! $zip_file ]
then
    echo 'Please pass the path to the drivers.zip file'
    echo "If you don't have it, type CTRL-C to exit"

    read zip_file
fi

if [ ! -f $zip_file ]
then
    echo "Zip file ($zip_file) does not exist" >&2
    exit 1
fi


# SET UP ENVIRONMENT

# We're trying to get the value for DTA_DATA and
# make it easy to get this value in the future

if [ ! $DTA_DATA ]
then
    # Check for existence of file DTA_ENV
    if [ -f ./DTA_ENV ]
    then
        # If it exists, source it
        . ./DTA_ENV
    else
        # Otherwise, assign 2nd param to data
        data=$2

        # If 2nd param wasn't passed
        if [ ! $data ]
        then
            # Give default value to data
            data=./data

            # Prompt for data dir
            echo 'Where would you like the data stored? [./data]'
            read response

            # If response, set data to it
            if [ $response ]
            then
                 data=$response
            fi
        fi

        # Make the path absolute
        if [[ ${data:0:1} == "/" ]]
        then
            DTA_DATA=$data
        else
            DTA_DATA=`pwd`/$data
        fi

        # Make DTA_DTA easily source-able
        echo "export DTA_DATA=$DTA_DATA" > ./DTA_ENV

        # Tell the use what we did
        echo "!!!"
        echo "I just wrote a file called DTA_ENV to your working directory"
        echo
        echo "It has an environment variable in it called DTA_DATA"
        echo
        echo "DTA_DATA is used frequently by this application"
        echo

        # Ask if they want their profile changed
        echo "Would you like me to add it to your .bash_profile? [y/N]"

        read response
        echo

        # Check response
        if [[ $response =~ ^[yY] ]]
        then
            # If yes, append export to end of .bash_profile...
            echo "export DTA_DATA=$DTA_DATA" >> ~/.bash_profile

            # ...and give user direction on how to
            # make this available once script exits
            echo "After this script finishes, you should exit and log back in"
            echo "(or source your .bash_profile again) for access to DTA_DATA"
            echo
        else
            # Otherwise, tell user how to do this later
            echo "No problem, just source it every time you start a new shell, e.g.:"
            echo
            echo "    . ./DTA_ENV"
            echo
            echo "Do this after this shell exits"
            echo
            echo "To add it later to your .bash_profile:"
            echo
            echo "    echo ./DTA_ENV >> .bash_profile"
            echo
        fi
    fi
fi


# SET UP DATA

# (data) is easier to type / read than (DTA_DATA)
data=$DTA_DATA

# Make data dir if it doesn't exist
if [ ! -d $data ]
then
    mkdir $data
fi

# Some convenience vars
drivers=$data/drivers
driver=$data/driver

# If we haven't done this already, unzip
# the zip file to the data directory
if [[ ! -d $drivers  && ! -d $driver ]]
then
    unzip -q $zip_file -d $data
fi

# Exit script if any command fails (
#   We couldn't do this before because the
#   zip file is malformed and exits non-zero
# )

set -e
set -o pipefail

###############################################
# I'm creating a directory structure suitable #
#           for a RESTful API.                #
#                                             #
#       /driver/$x/trip/$y/some-file          #
###############################################

# drivers/$x/{1..200}.csv --> driver/$x/trip/$y/coordinates-cartesian

if [ ! -d $driver ]
then
    mv $drivers $driver
fi


for driver in $driver/*
do
    if [ ! -d $driver/trip ]
    then
        mkdir $driver/trip
    fi

    for i in {1..200} # can assume that each driver has 200 trips
    do
        driver_trip=$driver/trip/$i

        if [ ! -f $driver_trip/coordinates-cartesian ]
        then
            csv=$driver/$i.csv

            if [ -f $csv ]
            then
                if [ ! -d $driver_trip ]
                then
                    mkdir $driver_trip
                fi

                sed -n '2,$p' $csv > $driver_trip/coordinates-cartesian # Strip the header
                rm $csv
            else
                echo "Neither ($driver_trip/coordinates-cartesian) nor ($csv) exists" >&2
                echo "Expected one or the other" >&2
                exit 1
            fi
        fi
    done
done


# Create a symolic link so the webapp
# can find the driver data

if [ ! -h public/driver ]
then
    ln -s $DTA_DATA/driver public/driver
fi
