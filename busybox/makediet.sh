#!/bin/bash
#
DIETPATH=""
DIETCMD=""
#EXTENTS="x86Os x86 x86mmxOs x86mmx k6p3 k7p4 k8p5 k9c2 atom coreix k10"

if [ "$1" != "" ]; then
 case $1 in
   --dietpath=*)
    DIETPATH="$(echo $1 | cut -f2 -d=)"
    DIETCMD="$DIETPATH/diet"
    shift
   ;;
 esac
else
  DIETPATH=/opt/dietlibc/bin
  DIETCMD=$DIETPATH/diet
fi
# dietlib parameter for path may finally be overwritten by this:
source ./cflags.config
if [ ! -e $DIETCMD ]; then
   echo "no valid diet command found , $DIETCMD does not exist "
   exit 1
fi


if [ "$1" != "" ]; then EXTENTS="$1 $2 $3 $4 $5 $6 $7"; fi
$DIETCMD make distclean
sleep 3
$DIETCMD make defconfig
sleep 3

sync
for EXT in $EXTENTS; do
 CROSS_COMPILE="$DIETCMD  "  $DIETCMD make distclean
 sleep 3
 sync
 echo "assigning DOT.config-$EXT"
 cp -f  ./DOT.config-$EXT  ./.config
 sleep 1
 assign_variables  $EXT
 echo "making busybox-$EXT according DOT.config-$EXT"
 HOSTCFLAGS=" $CONFIGVALUE " CFLAGS=" $CONFIGVALUE " LDFLAGS="  $CONFIGVALUE " EXTRA_CFLAGS=" $CONFIGVALUE " CROSS_COMPILE="$DIETCMD  "  $DIETCMD  make V=1
 sleep 2
 sync
 sleep 2
 if [ -d ./0_lib ]; then mv -f ./0_lib  ./lib-$EXT-0; fi
 mv -f ./busybox ./busybox-$EXT
 echo "Done busybox-$EXT !! "
done

CROSS_COMPILE="$DIETCMD  "  $DIETCMD make distclean
#
