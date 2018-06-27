#!/bin/bash
######################################
## 引数に取得したいコンテナIDが必要 ##
######################################
function _func_rosclient() {
    if [ -z "$1" ]; then
        echo "Input the Docker Conntener ID.'"
    else
        docker_addr=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $1)
        client_addr=$(ifconfig | grep 'inet addr:' | grep -v '127.0.0.1' | awk -F: '{print $2}' | awk '{print $1}' | head -1)
        export ROS_MASTER_URI=http://${docker_addr}:11311
        export ROS_HOST_NAME=${client_addr}
        export ROS_IP=${client_addr}
        export PS1="\[\033[44;1;33m\]<ROS_Docker_client>\[\033[0m\]\w$ "
    fi
    env | grep "ROS_MASTER_URI"
    env | grep "ROS_HOST_NAME"
    env | grep "ROS_IP"
}

function _func_rosexit(){
    export ROS_MASTER_URI=http://localhost:11311
    unset ROS_HOST_NAME
    unset ROS_IP
    export PS1="\u@\h:\w\\$ "
}

function _func_comp_rosaddress(){
    local cur=${COMP_WORDS[COMP_CWORD]}
    if [ "$COMP_CWORD" -eq 1 ]; then
        COMPREPLY=( $(compgen -W "client exit" -- $cur) )
    fi
}

function _func_rosaddress() {
    # Get now eth0 or wlan0 IP address
    if [ $1 = "exit" ]; then
        _func_rosexit
    elif [ $1 = "client" ]; then
        _func_rosclient $2
    fi
}

alias rosdocker=_func_rosaddress
complete -o default -F _func_comp_rosaddress rosdocker