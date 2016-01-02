#!/bin/busybox ash
#
#EXTENTS="x86Os x86 x86mmxOs x86mmx k6p3 k7p4 k8p5 k9c2 atom coreix k10 "
source ./cflags.config

if [ "$1" != "" ]; then EXTENTS="$1 $2 $3 $4 $5 $6 $7 $8 $9"; fi
make mrproper
sleep 1
make defconfig
sleep 1

sync
for EXT in $EXTENTS; do
  make mrproper
  echo "cleaning up ended with '$?'"
  sleep 1
  sync
  echo "assigning DOT.config-$EXT"
  cp -f  ./DOT.config-$EXT  ./.config
  sleep 1
  assign_variables  $EXT
  sync
  echo "making busybox-$EXT according DOT.config-$EXT"
 #HOSTCFLAGS=" $CONFIGVALUE " CFLAGS=" $CONFIGVALUE " LDFLAGS=" $CONFIGVALUE " EXTRA_CFLAGS=" $CONFIGVALUE " 
  make -j5 V=1 >> makerun-$EXT.txt 2>&1 
  echo "make busybox-$EXT ended with '$?'"
  sleep 1
  sync
  sleep 1
  if [ -d ./0_lib ]; then mv -f ./0_lib  ./lib-$EXT-0; fi
  if [ -e ./busybox ]; then
    mv -f ./busybox ./busybox-$EXT
  else
    echo "file  busybox-$EXT not generated, executable busybox does not exist"
  fi  
  echo "Done busybox-$EXT !! "
done

make mrproper
echo "cleaning up ended with '$?'"
sync 
sleep 1
sync
#if [ "$1" = "" ]; then
  echo "Make tar-ball with lzma compression?"
  read yesno
  if [ "$yesno" = "y" ] || [ "$yesno" = "yes" ]; then 
    exec ./mktarlzma
  else
    echo "Done make.sh !! "
  fi
#fi
exit $?
#

