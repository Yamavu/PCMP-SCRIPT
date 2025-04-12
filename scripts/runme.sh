#!/bin/bash

project_dir=`pwd`;

# echo "Project Dir = $project_dir"

if [ -d PicoCalc-micropython-driver ]; then
    rm -rf PicoCalc-micropython-driver
fi

git clone https://github.com/zenodante/PicoCalc-micropython-driver


if [ -d micropython ]; then
    rm -rf micropython
fi

git clone https://github.com/micropython/micropython

cd $project_dir
cp ./PicoCalc-micropython-driver/pico_files/fbconsole.py ./micropython/ports/rp2/modules
cp ./PicoCalc-micropython-driver/pico_files/picocalc.py ./micropython/ports/rp2/modules

cd $project_dir
cd micropython/ports/rp2
git submodule update --init --recursive

if [ -d build ]; then
    rm -rf build
fi

mkdir build
cd build

cmake .. \
    -DUSER_C_MODULES="$project_dir/PicoCalc-micropython-driver/micropython.cmake" \
    -DMICROPY_BOARD=RPI_PICO

#    RPI_PICO
#    RPI_PICO2
#    RPI_PICO2_W

bash <(wget -O - https://thonny.org/installer-for-linux )

cd $project_dir
mkdir transfer

cp micropython/ports/rp2/build/firmware.uf2 $project_dir/transfer/
cp PicoCalc-micropython-driver/pico_files/* $project_dir/transfer/

