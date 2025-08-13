#!/bin/bash

# this script compiles a firmware and all necessary files for filesystem
# this script is for pico 2w and includes eigenmath
#
# flash firmware by holding button and copying the transfer/firmware.uf2 to the Pico
# use thonny to copy the rest in transfer/ to pico filesystem root

project_dir=`pwd`;
PCMP_driver_dir="$project_dir/PicoCalc-micropython-driver";
uPY_dir="$project_dir/micropython";

user_modules=("picocalcdisplay" "vtterminal" "eigenmath_micropython")
target="RPI_PICO2_W" # supported: RPI_PICO , RPI_PICO2, RPI_PICO2_W

if [ ! "$uPY_dir/ports/rp2" ]; then
    mkdir --parents "$uPY_dir/ports/rp2"
    mkdir -p "$uPY_dir/ports/rp2/modules"
fi

if [ ! -d "$uPY_dir" ]; then
    git clone https://github.com/micropython/micropython "$uPY_dir"
fi
if [ ! -d "$PCMP_driver_dir" ]; then
    git clone https://github.com/zenodante/PicoCalc-micropython-driver $PCMP_driver_dir
fi

cp "$PCMP_driver_dir"/pico_files/modules/*.py "$uPY_dir/ports/rp2/modules"

if [ ! -d "$project_dir/transfer" ]; then
    mkdir "$project_dir/transfer"
    cp -r "$PCMP_driver_dir/pico_files/root_eigenmath/"* $project_dir/transfer
    cp -r "$PCMP_driver_dir/pico_files/examples" $project_dir/transfer
fi

if [ ! -f "$project_dir/transfer/firmware.uf2" ]; then
    cd $uPY_dir/ports/rp2
    git submodule update --init --recursive

    if [ -d build ]; then
        rm -rf build
    fi

    mkdir build
    cd build

    USER_C_MODULES=""
    for user_module in "${user_modules[@]}"; do
        if [ -n "$USER_C_MODULES" ]; then
            USER_C_MODULES="${USER_C_MODULES};"
        fi
        USER_C_MODULES="${USER_C_MODULES}${PCMP_driver_dir}/${user_module}/micropython.cmake"
    done

    cmake .. -DUSER_C_MODULES="$USER_C_MODULES" -DMICROPY_BOARD="$target" && \
    make && \
    cp "$uPY_dir/ports/rp2/build/firmware.uf2" $project_dir/transfer
fi


