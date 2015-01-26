#!/bin/bash

#
# init.sh
# bekar init

set -e
export WD="$(dirname $(readlink $0 || echo $0))"

trap 'echo -e File \"$0\", line ${LINENO}"\n\t"$(sed -n ${LINENO}p $0)' ERR

function Interactive {
    read -p "  url     : " url; echo "URL='$url'" > $FILE_CONF
    read -p "  author  : " author; echo "AUTHOR='$author'" >> $FILE_CONF
    read -p "  email   : " email; echo "EMAIL='$email'" >> $FILE_CONF
    read -p "  theme   : " theme; echo "THEME='$theme'" >> $FILE_CONF
    echo "For modification change '$FILE_CONF'"
}

function Usage {
    echo -e "Create static pages source directory"
    echo -e " Usage: bekar init [PATH]";
    echo -e "\t-i | --interactive  Ask about config"
    echo -e "\t-h | --help         Display this message"
}

GETOPT=$(getopt -o ih\
                -l interactive,help\
                -n "bekar init"\
                -- "$@")

eval set -- "$GETOPT"

while true; do
    case $1 in
        -i|--interactive) INTERACTIVE=1;;
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

FILE_CONF=$PATH_SRC/.bekar
echo -e "NoTitle\nNoSubtitle\nmyemail@domain.com\nrho" | Interactive
