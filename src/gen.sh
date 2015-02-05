#!/bin/bash

#
# bekar gen

set -e
export WD="$(dirname $(readlink $0 || echo $0))"

source $WD/lib.func

lib_find-up ".bekar" || { # set the PATH_CONFIG
    echo "Not a bekar static pages source directory"
    exit
}

function Usage {
    echo -e "Generate a static page"
    echo -e " Usage: bekar gen [FILE(s)]";
    echo -e "\t-w | --watch        Watch over changes and generate"
    echo -e "\t-o | --output [DES] Specify Output Directory"
    echo -e "\t                    (default: <source-dir>/static-gen/)"
    echo -e "\t-v | --verbose      Increase verbosity"
    echo -e "\t-h | --help         Display this message"
}

GETOPT=$(getopt -o wo:vh\
                -l watch,output:,verbose,help\
                -n "bekar gen"\
                -- "$@")

eval set -- "$GETOPT"

WATCH_FLAG=0 VV=2
exec 3> /dev/null
exec 4> /dev/null
while true; do
    case $1 in
        -w|--watch)       WATCH_FLAG=1; shift;;
        -v|--verbose)     let VV++; eval "exec $VV>&2"; shift;;
        -h|--help)        Usage; exit;;
        --)               shift; break
    esac
done

# emacs 001-blog.org --batch -f org-html-export-to-html --kill

lib_find-up ".bekar" || {
    echo "Not a bekar static pages source directory"
    exit
}


function index {

}
