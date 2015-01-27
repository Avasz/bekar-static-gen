#!/bin/bash

#
# init.sh
# bekar init

set -e
export WD="$(dirname $(readlink $0 || echo $0))"

trap 'echo -e File \"$0\", line ${LINENO}"\n\t"$(sed -n ${LINENO}p $0)' ERR

function Interactive {
    rm -f $FILE_CONF
    read -p "  author (default: $NAME): " author
    let author || author=$NAME
    echo "AUTHOR='$author'" >> $FILE_CONF

    read -p "  email: " email; echo "EMAIL='$email'" >> $FILE_CONF

    read -p "  theme (default: rho): " theme
    let theme || theme="rho"
    echo "THEME='$theme'" >> $FILE_CONF

    read -p "  url: " url; echo "URL='$url'" >> $FILE_CONF

    read -p "  output (default: ./gen/): " theme
    let theme || theme=".gen/"
    echo "OUTPUT='$theme'" >> $FILE_CONF

    >&3 cat $FILE_CONF
    >&3 echo "For modification change '$FILE_CONF'"
    exit
}

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

INTERACTIVE=0
exec 3> /dev/null
while true; do
    case $1 in
        -i|--interactive) INTERACTIVE=1; shift;;
        -v|--verbose)     exec 3>&2; shift;;
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
NAME=$(awk -F':' "/$USER/ {print \$5}" /etc/passwd)

let INTERACTIVE && Interactive
echo -e "\n\n\n\n\n" | Interactive
