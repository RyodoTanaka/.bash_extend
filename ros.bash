#!/bin/bash

if [ -n "$1" ]; then
    version=$1
else
    version="kinetic"
fi

source /opt/ros/$version/setup.bash
export ROS_PARALLEL_JOBS=-j$((`nproc`-1))
source `catkin locate --shell-verbs`
