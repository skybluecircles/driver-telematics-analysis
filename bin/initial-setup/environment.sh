#!/bin/bash

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
        # Otherwise, assign 1st param to data
        data=$1

        # If 1st param wasn't passed
        if [ ! $data ]
        then
            # Give default value to data
            data=data

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
            echo "Do this after this script exits"
            echo
            echo "To add it later to your .bash_profile:"
            echo
            echo "    echo ./DTA_ENV >> .bash_profile"
            echo
        fi
    fi
fi
