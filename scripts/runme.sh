#!/bin/bash

project_dir=`pwd`;
PCMP_driver_dir="$project_dir/PicoCalc-micropython-driver";
uPY_dir="$project_dir/micropython";

modules=("picocalcdisplay" "vtterminal")
target="RPI_PICO" # supported: RPI_PICO , RPI_PICO2, RPI_PICO2_W

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
    cp -r "$PCMP_driver_dir/pico_files/root/"* $project_dir/transfer
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
    for module in "${modules[@]}"; do
        if [ -n "$USER_C_MODULES" ]; then
            USER_C_MODULES="${USER_C_MODULES};"
        fi
        USER_C_MODULES="${USER_C_MODULES}${PCMP_driver_dir}/${module}/micropython.cmake"
    done

    cmake .. -DUSER_C_MODULES="$USER_C_MODULES" -DMICROPY_BOARD="$target" && \
    make && \
    cp "$uPY_dir/ports/rp2/build/firmware.uf2" $project_dir/transfer
fi


