       BusyBox Tools
##########################################################

Download your copy of busybox, unpack and do the following:

---------------------------------
cp DOT.config-x86Os .config

make

cp busybox busybox-x86Os

./update.sh static

./make.sh

-------------------------------
This should result in a complete set 
