#!/bin/bash

# Must be run in dotfiles git repo 

## Funcs

# this function links all 
LinkDir () #$1 = myDotFile location, $2 = target location $3 = force flag
{
    pushd "$1" > /dev/null
    echo "now in dir $2"
    for i in $(ls -a | grep -e ^[.][[:alnum:]] -e ^[^.]); do

        if [ -d "$i" ]; then
            echo ""
            LinkDir "$i" "$2"/"$i" "$3"
        elif [ ! -f "$2/$i" ]; then
            echo "$i is not at $2/$i. Making link now."
            ln -s "$(pwd)/$i" "$2/$i"
        else
            # if force flag given, delete
            if [ "$3" -eq "1" ]; then
                echo "removing old $i and replacing with link"
                rm "$2/$i"
                ln -s "$(pwd)/$i" "$2/$i"
            else
                echo "$i already in $2, use the force flag to replace it."
            fi
        fi
    done
    popd > /dev/null
}

FORCE=0

while getopts "f" opt; do
    case $opt in
        f)  FORCE='1'
            ;;
        *)  echo 'Usage: no args for normal use, -f for override current files'
            exit 1
            ;;
    esac
done

DD=$(pwd)/myDotFiles

LinkDir "$DD" ~ "$FORCE"
