#!/bin/bash

#
# bekar status

set -e
export WD="$(dirname $(readlink $0 || echo $0))"

source $WD/lib.func

function Usage {
    echo -e "Show current status"
    echo -e " Usage: bekar status"
    echo -e "\t-v | --verbose      Increase verbosity"
    echo -e "\t-h | --help         Display this message"
}

GETOPT=$(getopt -o vh\
                -l verbose,help\
                -n "bekar status"\
                -- "$@")

eval set -- "$GETOPT"

VV=2
exec 3> /dev/null
exec 4> /dev/null
while true; do
    case $1 in
        -v|--verbose)     let VV++; eval "exec $VV>&2"; shift;;
        -h|--help)        Usage; exit;;
        --)               shift; break
    esac
done

## lib_find-up is here for verbose mode
lib_find-up ".bekar" || { # set the PATH_CONFIG
    echo "Not a bekar static pages source directory"
    exit
}

while read i; do
    echo -n "$i"
    [ -e "$i" ] || echo -e " Deleted" && echo
done < $PATH_CONFIG/.genlist
