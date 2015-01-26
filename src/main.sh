#!/usr/bin/bash

#
# main.sh
# bekar controller

set -e
export WD="$(dirname $(readlink $0 || echo $0))"

trap 'echo -e File \"$0\", line ${LINENO}"\n\t"$(sed -n ${LINENO}p $0)' ERR

function Credits {
    h1="\033[1;32m" cdef="\033[0;0m"
    sed 's/^#.*/'`echo -e $h1`'&'`echo -e $cdef`'/' $WD/../AUTHORS
    echo
}

function Usage {
    echo -e "bekar - A Static Page CLI Generator"
    echo -e " Usage: bekar [OPTION] <command> [<args>]";
    echo -e "\t-h | --help     Display this message"
    echo -e "\t-c | --credits  Say hello to developers"
    echo -e "\t-v | --verbose  Verbose mode"
    echo -e " Commands:"
    echo -e "    init    [PATH]     Create static pages source directory"
    echo -e "    add     [FILE(s)]     Add the page to generation list"
    echo -e "    rm      [FILE(s)]     Remove the page from generation list"
    echo -e "    gen     [OPTIONS]  Generate a static page"
    echo -e "    version            Show version information"
}

case $1 in
    init)    shift; exec $WD/init.sh $@;;
    add)     shift; exec $WD/add.sh $@;;
    rm)      shift; exec $WD/rm.sh $@;;
    gen)     shift; exec $WD/gen.sh $@;;
    version) cat $WD/../.version; exit;;
esac

GETOPT=$(getopt -o hc\
                -l help,credits,version\
                -n "bekar"\
                -- "$@")

eval set -- "$GETOPT"

while true; do
    case $1 in
        -h|--help)      Usage; exit;;
        -c|--credits)   Credits; exit;;
        --version)      cat $WD/../.version; exit;;
        --)             shift; break
    esac
done

Usage
