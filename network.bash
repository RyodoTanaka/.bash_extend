#!/bin/bash

function _func_mac2ip() {
    # Reference
    # https://stackoverflow.com/questions/13552881/can-i-determine-the-current-ip-from-a-known-mac-address
    ip neighbor | grep $1 | cut -d" " -f1
}

function _func_ip2mac() {
    # Reference
    # https://stackoverflow.com/questions/13552881/can-i-determine-the-current-ip-from-a-known-mac-address
    ip neighbor | grep $1 | cut -d" " -f5   
}

alias mac2ip=_func_mac2ip
alias ip2mac=_func_ip2mac
