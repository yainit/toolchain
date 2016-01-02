#!/bin/busybox ash
#
#EXTENTS="x86Os x86 x86mmx x86mmxOs k6p3 k7p4 k8p5 k9c2 atom ix"
#BBCFG=`./busybox-x86Os bbconfig`
# replicate
line=""
EXT=""
#CONFIGVALUE=""
#
STANDALONE=""
# 1. with CONFIG_STATIC=y you get a position independent static executable
# which needs no shared library
# 2. with "CONFIG_BUILD_LIBBUSYBOX=y" and "CONFIG_FEATURE_SHARED_BUSYBOX=y"
#  you get both a position independent executable needing system shared libs
#  and a very small position dependent executable needing libbusybox and system shared libs
if [ "$1" != "" ]; then
   STANDALONE=$1
fi

source ./cflags.config

if [ "$2" != "" ]; then
  EXTENTS="$2 $3 $4 $5 $6 $7 $8 $9"
fi

for EXT in $EXTENTS; do
   rm DOT.config-$EXT
done

sleep 2
sync

# add lines CONFIG_EXTRA_CFLAGS="" to each config-EXT
   #cp -f  DOT.config-x86Os  DOT.config-x86
write_dot_conf()
{
   local LINECONTENT
   LINECONTENT=""
   echo "Writing config file DOT.config-$EXT ...."
   #./busybox-x86Os bbconfig | while read line; do
    if [ "$STANDALONE" != "" ]; then
      if [ "$STANDALONE" = "static" ]; then
      ./busybox-x86Os bbconfig | while read line; do
       if [ "$(echo $line | grep "# CONFIG_STATIC is not set" 2>/dev/null)" != "" ]; then
         echo  "CONFIG_STATIC=y" >> DOT.config-$EXT
       elif [ "$(echo $line | grep "CONFIG_FEATURE_SHARED_BUSYBOX=y" 2>/dev/null)" != "" ]; then
        echo  "# CONFIG_FEATURE_SHARED_BUSYBOX is not set" >> DOT.config-$EXT
       elif [ "$(echo $line | grep "CONFIG_PIE=y" 2>/dev/null)" != "" ]; then
        echo  "# CONFIG_PIE is not set" >> DOT.config-$EXT
       elif [ "$(echo $line | grep "CONFIG_BUILD_LIBBUSYBOX=y" 2>/dev/null)" != "" ]; then
        echo "# CONFIG_BUILD_LIBBUSYBOX is not set" >> DOT.config-$EXT
       elif [ "$(echo $line | grep "CONFIG_EXTRA_CFLAGS=\"" 2>/dev/null)" != "" ]; then
        echo "CONFIG_EXTRA_CFLAGS=\"$CONFIGVALUE\"" >> DOT.config-$EXT
       else
        echo "$line" >> DOT.config-$EXT
       fi
       done
      fi
      
      if [ "$STANDALONE" = "empty" ]; then
       ./busybox-x86Os bbconfig | while read line; do
       LINECONTENT="$(echo $line | cut -f1 -d '=' 2>/dev/null)"
       #echo "$LINECONTENT"
       case $LINECONTENT in
         CONFIG_STATIC)
           echo  "# CONFIG_STATIC is not set" >> DOT.config-$EXT
         ;;
         CONFIG_FEATURE_SHARED_BUSYBOX)
           echo  "# CONFIG_FEATURE_SHARED_BUSYBOX is not set" >> DOT.config-$EXT
         ;;  
         CONFIG_PIE)
           echo  "# CONFIG_PIE is not set" >> DOT.config-$EXT
         ;;
         CONFIG_BUILD_LIBBUSYBOX)
           echo "# CONFIG_BUILD_LIBBUSYBOX is not set" >> DOT.config-$EXT
         ;;
         CONFIG_FEATURE_INDIVIDUAL)
           echo "# CONFIG_FEATURE_INDIVIDUAL is not set" >> DOT.config-$EXT
         ;;
         CONFIG_EXTRA_CFLAGS)
           echo "CONFIG_EXTRA_CFLAGS=\"$CONFIGVALUE\"" >> DOT.config-$EXT
         ;;
         *)
           echo "$line" >> DOT.config-$EXT
         ;;
       esac      
       done
      fi

      if [ "$STANDALONE" = "shared" ]; then
       ./busybox-x86Os bbconfig | while read line; do
       LINECONTENT="$(echo $line | cut -f1 -d '=' 2>/dev/null)"
       #echo "$LINECONTENT"
       case $LINECONTENT in
         CONFIG_STATIC)
           echo  "# CONFIG_STATIC is not set" >> DOT.config-$EXT
         ;;
         '# CONFIG_FEATURE_SHARED_BUSYBOX is not set')
           echo "CONFIG_FEATURE_SHARED_BUSYBOX=y" >> DOT.config-$EXT
         ;;  
         CONFIG_PIE)
           echo  "# CONFIG_PIE is not set" >> DOT.config-$EXT
         ;;
         '# CONFIG_BUILD_LIBBUSYBOX is not set')
           echo "CONFIG_BUILD_LIBBUSYBOX=y" >> DOT.config-$EXT
         ;;
         #CONFIG_FEATURE_INDIVIDUAL)
         #  echo "# CONFIG_FEATURE_INDIVIDUAL is not set" >> DOT.config-$EXT
         #;;
         CONFIG_EXTRA_CFLAGS)
           echo "CONFIG_EXTRA_CFLAGS=\"$CONFIGVALUE\"" >> DOT.config-$EXT
         ;;
         *)
           echo "$line" >> DOT.config-$EXT
         ;;
       esac      
       done
      fi


    else
       # just copy 
       #if [ "$(echo $line | grep "CONFIG_STATIC=y" 2>/dev/null)" != "" ]; then
       #{
        #echo "# CONFIG_STATIC is not set" >> DOT.config-$EXT
        #echo "# CONFIG_PIE is not set" >> DOT.config-$EXT
        #echo "CONFIG_BUILD_LIBBUSYBOX=y" >> DOT.config-$EXT
        #echo "CONFIG_FEATURE_SHARED_BUSYBOX=y" >> DOT.config-$EXT
       #}
       #elif [ "$(echo $line | grep '# CONFIG_FEATURE_SHARED_BUSYBOX is not set' 2>/dev/null)" != "" #]; then
       # echo "CONFIG_FEATURE_SHARED_BUSYBOX=y" >> DOT.config-$EXT
       #elif [ "$(echo $line | grep "CONFIG_PIE=y" 2>/dev/null)" != "" ]; then
       # echo "# CONFIG_PIE is not set" >> DOT.config-$EXT
       #elif [ "$(echo $line | grep "# CONFIG_BUILD_LIBBUSYBOX is not set" 2>/dev/null)" != "" ]; then
      #  echo "CONFIG_BUILD_LIBBUSYBOX=y" >> DOT.config-$EXT
       #elif [ "$(echo $line | grep "CONFIG_EXTRA_CFLAGS=\"" 2>/dev/null)" != "" ]; then
       ./busybox-x86Os bbconfig | while read line; do
       if [ "$(echo $line | grep "CONFIG_EXTRA_CFLAGS=\"" 2>/dev/null)" != "" ]; then
        echo "CONFIG_EXTRA_CFLAGS=\"$CONFIGVALUE\"" >> DOT.config-$EXT
       else
        echo "$line" >> DOT.config-$EXT
       fi
       done
    fi
   #done
}

EXT=""
for EXT in $EXTENTS; do
  #CONFIGVALUE=${CONFIG$EXT}
  assign_variables $EXT
  #echo "config-$EXT=$CONFIGVALUE"
  write_dot_conf
done

sleep 2
sync
echo "Done creation of DOT.config through all extents !!"
# save
#./busybox-x86Os bbconfig > DOT.config-x86Os
cp -f DOT.config-x86Os DOT.config-x86Os.backup
#
#
exit 0
