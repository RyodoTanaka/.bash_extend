#!/bin/bash

function _func_fsize() {
    if [ -n "$1" ]; then
        du -sh $1
    else
        du -sh .
    fi
}
    
alias fsize=_func_fsize
