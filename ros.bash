#!/bin/bash

function catkin-compile-commands-json() {
    local catkin_ws=$(echo $CMAKE_PREFIX_PATH | cut -d: -f1)/..
    # Verify catkin cmake args contains -DCMAKE_EXPORT_COMPILE_COMMANDS=ON.
    # If the arguments does not include the option, add to cmake args.
    (cd "${catkin_ws}" && catkin config | grep -- -DCMAKE_EXPORT_COMPILE_COMMANDS=ON >/dev/null)
    local catkin_config_contains_compile_commands=$?
    if [ $catkin_config_contains_compile_commands -ne 0 ]; then
        echo catkin config does not include -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
        (
            cd "${catkin_ws}" &&
                catkin config -a --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -std=c++17
        )
    fi
    # Run catkin build in order to run cmake and generate compile_commands.json
    (cd "${catkin_ws}" && catkin build)
    # Find compile_commands.json in build directory and create symlink to the top of the package
    # directories.
    local package_directories=$(find "${catkin_ws}/src" -name package.xml | xargs -n 1 dirname)
    for package_dir in $(echo $package_directories); do
        local package=$(echo $package_dir | xargs -n 1 basename)
        (
            cd "${catkin_ws}"
            if [ -e ${catkin_ws}/build/$package/compile_commands.json ]; then
                ln -sf ${catkin_ws}/build/$package/compile_commands.json \
                    $(rospack find $package)/compile_commands.json
            fi
        )
    done
}


if [ -n "$1" ]; then
    version=$1
else
    version="kinetic"
fi

source /opt/ros/$version/setup.bash
export ROS_PARALLEL_JOBS=-j$((`nproc`-1))
source `catkin locate --shell-verbs`
