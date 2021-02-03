#!/bin/bash

function _func_mac2ip() {
    ip neighbor | grep $1 | cut -d" " -f1
}

function _func_ip2mac() {
    ip neighbor | grep $1 | cut -d" " -f5   
}

alias mac2ip=_func_mac2ip
alias ip2mac=_func_ip2mac
