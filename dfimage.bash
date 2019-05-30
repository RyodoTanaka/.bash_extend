#!/bin/bash

function _func_dfimage() {
    IMAGE="$1"
    BASE_IMAGE=`docker inspect -f "{{len .RepoDigests }}" $IMAGE`
    if [ $BASE_IMAGE -eq 0 ]; then
        BASE_IMAGE=`docker inspect -f "{{ .Config.Image }}" $IMAGE`
    else
        BASE_IMAGE=`docker inspect -f "{{index .RepoDigests 0}}" $IMAGE`
    fi
    
    USER="root"
    if [ -n "$2" ]; then
        USER="$2"
    fi
    
    # Print base image
    echo "FROM $BASE_IMAGE"

    # Get bash history commands
    docker run -it -u $USER $IMAGE cat /$USER/.bash_history | sed 's/\r$//g' > .tmp.txt
    HEAD_CMD=$(head -n 1 .tmp.txt)
    sed -i '1d' .tmp.txt
    TAIL_CMD=$(tail -n 1 .tmp.txt)
    sed -i '$d' .tmp.txt

    # make commands
    echo "RUN $HEAD_CMD && \\"
    cat .tmp.txt | while read cmd; do
        cmd=`echo $cmd | sed -e 's/apt\-get/apt/g' -e 's/apt/apt\ \-y/g'`
        if [ "$cmd" = "ls" ]; then
            continue
        fi
        echo "    $cmd && \\"
    done
    echo "    $TAIL_CMD"

    # Delete tempolary file
    rm -rf .tmp.txt
}

alias dfimage=_func_dfimage
