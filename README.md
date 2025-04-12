# PCMP-script

an MIT licensed bash script to automatically download everything ncessary to get micropython running on your clockwork-pi picocalc. 

pretty simple, but less error prone than manually doing the steps.

based on the instructions you can find here: https://github.com/zenodante/PicoCalc-micropython-driver

works on ubuntu with python and git installed, should work from windows WSL, let me know if it works for you.

currently parameter is set for the included RPI PICO board. if you have upgraded to a RPI2 or RPI2W, edit line 36 from RPI_PICO to RPI_PICO2 or RPI_PICO2_W
 



## Steps

1. clone this repo somewhere

~~~
git clone <this repos url>
~~~

2. Inside the folder...

~~~
cd build
../scipts/runme.sh
~~~

There will be a couple of times when you have to press ENTER or type Y to accept.

3. Use BOOTSEL and Thonny to move the files over to your PicoCalc in the usual way. Not managed to automate this step yet.



## TODO

[ ] Update the script so it only carries out steps if they are necessary.
    [ ] Only Pull and Compile the Repos if Out of Date
    [ ] Install Thonny only if missing 


## Thanks

Thanks go to zenodate & LaikaSpaceDawg for their programming generosity.