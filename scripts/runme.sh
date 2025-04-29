#!/bin/bash


echo ""
echo "Please Choose the Hardware you Have Installed"
echo "If in doubt choose RPI_PICO (1) its what ships with your picocalc"
echo ""


PS3="Select your HARDWARE please: "

select hardware in RPI_PICO RPI_PICO2 RPI_PICO2_W Quit
do
    case $hardware in
        "RPI_PICO") 
            echo "you chose $hardware - first gen pico"
            break
            ;;
        "RPI_PICO2") 
            echo "you chose $hardware - pico second gen"
            break
            ;;
        "RPI_PICO2_W") 
            echo "you chose $hardware - pico second gen with wifi"
            break
            ;;
        "Quit") 
            echo "you chose $hardware - bye"
            exit 1
            break
            ;;
        *) 
            echo "Ooops"
            ;;
    esac
done

echo ""
echo "Please Choose the FILESYSTEM Behaviour You Want"
echo "I prefer to choose OVERWRITE_FILESYSTEM (1) it will overwrite with necessary files"
echo ""

PS3="Select your FileSystem Behavioud please: "

select filesystem in WITH_FILESYSTEM WITHOUT_FILESYSTEM Quit
do
    case $filesystem in
        "WITH_FILESYSTEM") 
            echo "you chose $filesystem - overwrite with python files"
            break
            ;;
        "WITHOUT_FILESYSTEM") 
            echo "you chose $filesystem - safe filesystem, python linked to binary"
            break
            ;;
        "Quit") 
            echo "you chose $filesystem - bye"
            exit 1
            break
            ;;
        *) 
            echo "Ooops"
            ;;
    esac
done


project_dir=`pwd`;

echo "Project Dir = $project_dir"

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



#    RPI_PICO
#    RPI_PICO2
#    RPI_PICO2_W


cmake .. \
    -DUSER_C_MODULES="$project_dir/PicoCalc-micropython-driver/picocalcdisplay/micropython.cmake;$project_dir/PicoCalc-micropython-driver/vtterminal/micropython.cmake" \
    -DMICROPY_BOARD=$hardware

# bash <(wget -O - https://thonny.org/installer-for-linux )

cd $project_dir


if [ -d transfer ]; then
    rm -rf transfer
fi

mkdir transfer

if [ $filesystem  == "WITH_FILESYSTEM" ]; then
    cp -r micropython/ports/rp2/build/picocalc_micropython_withfilesystem_pico.uf2 $project_dir/transfer/
fi

if [ $filesystem == "WITHOUT_FILESYSTEM" ]; then
    cp -r micropython/ports/rp2/build/picocalc_micropython_NOfilesystem_pico.uf2 $project_dir/transfer/
fi

# cp -r micropython/ports/rp2/build/firmware.uf2 $project_dir/transfer/
# cp -r PicoCalc-micropython-driver/pico_files/* $project_dir/transfer/

