#!/bin/bash

# this script compiles a firmware and all necessary files for filesystem
# this script is for pico 2w and includes eigenmath
#
# flash firmware by holding button and copying the transfer/firmware.uf2 to the Pico
# use thonny to copy the rest in transfer/ to pico filesystem root

# USING PicoCalc Bios 1.2 until 1.4 is ironed out https://forum.clockworkpi.com/t/picocalc-micropython-port-status/16669/73

project_dir=`pwd`;
PCMP_git="https://github.com/zenodante/PicoCalc-micropython-driver"
PCMP_dir="$project_dir/PicoCalc-micropython";
MP_git="https://github.com/micropython/micropython.git"
MP_branch="v1.26-release" #"master"
MP_dir="$project_dir/micropython";

user_modules=("picocalcdisplay" "vtterminal") # "eigenmath_micropython")
target="RPI_PICO2_W" # supported: RPI_PICO , RPI_PICO2, RPI_PICO2_W

if [ ! "$MP_dir/ports/rp2" ]; then
    mkdir --parents "$MP_dir/ports/rp2"
    mkdir -p "$MP_dir/ports/rp2/modules"
fi

if [ ! -d "$MP_dir" ]; then
    git clone -b $MP_branch $MP_git "$MP_dir"
fi
if [ ! -d "$PCMP_dir" ]; then
    git clone $PCMP_git $PCMP_dir
fi
#if [ ! -d "$PCMP_dir/eigenmath_micropython" ]; then
#    git clone https://github.com/zenodante/eigenmath_micropython.git "$PCMP_dir/eigenmath_micropython"
#fi

cp "$PCMP_dir"/pico_files/modules/*.py "$MP_dir/ports/rp2/modules"

if [ ! -d "$project_dir/transfer" ]; then
    mkdir "$project_dir/transfer"
#    cp -r "$PCMP_dir/pico_files/root_eigenmath/"* $project_dir/transfer
    cp -r "$PCMP_dir/pico_files/root/"* $project_dir/transfer
    cp -r "$PCMP_dir/pico_files/examples" $project_dir/transfer
fi

if [ ! -f "$project_dir/transfer/firmware.uf2" ]; then
    cd $MP_dir/ports/rp2
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
        USER_C_MODULES="${USER_C_MODULES}${PCMP_dir}/${user_module}/micropython.cmake"
    done

    cmake .. -DUSER_C_MODULES="$USER_C_MODULES" -DMICROPY_BOARD="$target" && \
    make && \
    cp "$MP_dir/ports/rp2/build/firmware.uf2" $project_dir/transfer
fi


