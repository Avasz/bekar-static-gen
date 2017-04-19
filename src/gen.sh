#!/bin/bash

#
# bekar gen

set -e
export WD="$(dirname $(readlink $0 || echo $0))"

source $WD/lib.func

function Usage {
    echo -e "Generate a static page"
    echo -e " Usage: bekar gen [FILE(s)]";
    echo -e "\t-w | --watch        Watch over changes and generate"
    echo -e "\t-l | --link         link assets (css, js, images)"
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

FLAG_WATCH=0 VV=2
exec 3> /dev/null
exec 4> /dev/null
while true; do
    case $1 in
        -w|--watch)       FLAG_WATCH=1; shift;;
        -o|--output)      OUTPUT= shift 2;;
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

export PATH_gen="$PATH_CONFIG/${OUTPUT:=static-gen/}"
export PATH_templates="$PATH_CONFIG/templates"


function gen_page {
    # mkdir -p "$PATH_OUTPUT"/{css,img,js}
    echo $PWD
    export PYTHONPATH=$WD
    while read i; do
        local base=$(dirname $i)
        echo $i
        if [[ ! -e "$i" ]]; then
           echo "$i not found"
           continue
        fi

        > /dev/null rsync --update --relative "$i" "$PATH_gen"
        [[ ${i##*.} == "org" ]] && python -c "import main; main.gen_blog('$base')"
        # local TEMP=$(mktemp)
        # cp "$PATH_TEMPLATE/page.html" "$PATH_OUTPUT/index.html" # TODO: use layout later
        # markdown "$i" | sed 's/^/        /' > $TEMP
        # sed -i "/<section>/r $TEMP" "$PATH_OUTPUT/index.html"
    done < "$PATH_CONFIG/.genlist"

    # emacs 001-blog.org --batch -f org-html-export-to-html --kill
    # cp $WD/../assets/css/bekar.css "$PATH_OUTPUT/css/"
    # cp $WD/../assets/img/symphony.png "$PATH_OUTPUT/img/"
    return 0
}

gen_page
