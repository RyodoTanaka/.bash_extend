#!/bin/bash

if [ -n "$1" ]; then
    $version=$1
else
    $version="indigo"
fi

source /opt/ros/$version/setup.bash
export ROS_PARALLEL_JOBS=-j`nproc`
source `catkin locate --shell-verbs`
