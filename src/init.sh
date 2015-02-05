#!/bin/bash

#
# bekar init

set -e
export WD="$(dirname $(readlink $0 || echo $0))"

function Usage {
    echo -e "Create static pages source directory"
    echo -e " Usage: bekar init [PATH]";
    echo -e "\t-i | --interactive  Ask about config"
    echo -e "\t-v | --verbose      Increase verbosity"
    echo -e "\t-h | --help         Display this message"
}

GETOPT=$(getopt -o ivh\
                -l interactive,verbose,help\
                -n "bekar init"\
                -- "$@")

eval set -- "$GETOPT"

INTERACTIVE_FLAG=0 VV=2
exec 3> /dev/null
while true; do
    case $1 in
        -i|--interactive) INTERACTIVE_FLAG=1; shift;;
        -v|--verbose)     let VV++; eval "exec $VV>&2"; shift;;
        -h|--help)        Usage; exit;;
        --)               shift; break
    esac
done

# extra argument
PATH_SRC=$(pwd)
for arg do
    PATH_SRC=$arg
    break
done

function Interactive {
    rm -f $FILE_CONF
    read -p "  author (default: $NAME): " author
    let author || author=${NAME:-$USER}
    echo "AUTHOR='$author'" >> $FILE_CONF

    read -p "  email: " email; echo "EMAIL='$email'" >> $FILE_CONF

    read -p "  theme (default: bekar): " theme
    let theme || theme="bekar"
    echo "THEME='$theme'" >> $FILE_CONF

    read -p "  url: " url; echo "URL='$url'" >> $FILE_CONF

    read -p "  output (default: ./gen/): " output
    let output || theme="./gen/"
    echo "OUTPUT='$theme'" >> $FILE_CONF

    >&3 cat $FILE_CONF
    >&3 echo "For modification change '$FILE_CONF'"
    exit
}

FILE_CONF=$PATH_SRC/.bekar
NAME=$(awk -F':' "/$USER/ {print \$5}" /etc/passwd)

let INTERACTIVE_FLAG && Interactive
echo -e "\n\n\n\n\n" | Interactive
