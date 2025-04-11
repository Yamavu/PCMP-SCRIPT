# PCMP-script

an MIT licensed bash script to automatically download everything ncessary to get micropython running on your picocalc. pretty simple, but less error prone than manually doing the steps.

works on ubuntu with python and git installed, should work from windows WSL, let me know if it works for you.

currently paraeter is set for the included RPI PICO board. if you have upgraded to a RPI2 or RPI2W, edit line 36 from RPI_PICO to RPI_PICO2 or RPI_PICO2_W
 
## Steps

1. clone this repo somewhere

git clone <this repos url>

2. Inside the folder...

~~~
cd build
../scipts/runme.sh
make
~~~

3. Use BOOTSEL and Thonny to move the files over to your PicoCalc in the usual way. Not managed to automate this step yet.

