       BusyBox Tools
##########################################################

Download your copy of busybox, unpack, copy the files below
into the source tree and do the following:

---------------------------------

-> cp DOT.config-x86Os .config

-> make

if necessary correct with
-> make xconfig 

-> cp busybox busybox-x86Os

-> ./update.sh static

-> ./make.sh

if neceesary correct the parameters in cflags.config
If you are using compilers after the gcc-4.8.2 and want 
to benefit of VFAT32 partition access on HDDs larger than 1TB,
then apply the  'tune-gcc482-busybox.diff' patch. 


-------------------------------


This should result in a complete set 


