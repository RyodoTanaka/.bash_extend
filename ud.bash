#!/bin/bash

function _func_ud() {
    if [ -n "$1" ]; then
        for i in `seq 1 $1`; do
            cd ..
        done
    else
        cd ..
    fi
}
    
alias ud=_func_ud
