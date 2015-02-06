#!/bin/bash

#
# bekar add

set -e
export WD="$(dirname $(readlink $0 || echo $0))"

source $WD/lib.func

function Usage {
    echo -e "Add the page to generation list"
    echo -e " Usage: bekar add [OPTION(s)] [FILE(s)|PATH]"
    echo -e "\t-r | --recursive    Ask about config"
    echo -e "\t-v | --verbose      Increase verbosity"
    echo -e "\t-h | --help         Display this message"
}

GETOPT=$(getopt -o rvh\
                -l recursive,verbose,help\
                -n "bekar add"\
                -- "$@")

eval set -- "$GETOPT"

FLAG_RECURSIVE=0 VV=2
exec 3> /dev/null
exec 4> /dev/null
while true; do
    case $1 in
        -r|--recursive)   echo "recursion not implemented"; exit; shift;;
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

PATH_FROM_ROOT=${PWD#$PATH_CONFIG/}
[[ $PATH_FROM_ROOT == $PWD ]] && PATH_FROM_ROOT="."

COUNT_FOUND=0
for arg; do # extra argument
    [[ -e $arg ]] || {
        echo "'$arg' did not match any files/directory"
        continue
    }
    [[ $arg == "." ]] && {
        for i in *; do
            COUNT_FOUND=$((COUNT_FOUND+1))
            echo ${PATH_FROM_ROOT}/${i} >> $PATH_CONFIG/.genlist
        done
        continue
    }
    # TODO: expansion and recursion
    # [[ -d $arg ]] && {
    #     echo expanding $arg
    #     find $arg -type f #-not -path '*/\.*'
    # }
    echo $PATH_FROM_ROOT/$arg >> $PATH_CONFIG/.genlist
    COUNT_FOUND=$((COUNT_FOUND+1))
done

function Normalize {
    DUPLICATE=$(sort $PATH_CONFIG/.genlist | uniq -d | wc -l)
    let COUNT_FOUND-=DUPLICATE
    if (( COUNT_FOUND == 0 )); then
        echo "File already in generation list"
        return
    fi
    echo $COUNT_FOUND files added
    sort -u $PATH_CONFIG/.genlist -o $PATH_CONFIG/.genlist
    >&3 cat $PATH_CONFIG/.genlist
    exit 0
}

let COUNT_FOUND && Normalize
echo "Nothing specified, nothing added."
echo "Maybe you wanted to say 'bekar add .'?"
