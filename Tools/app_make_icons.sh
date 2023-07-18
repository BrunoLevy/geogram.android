#!/bin/sh
SCRIPT_DIR=$(dirname "$0")

APP_DIR=$1

if [ ! -d $APP_DIR/app/src/main/res ]; then
   echo did not find app/src/main/res
   echo app_make_icons.sh should be run in app source directory
   exit
fi

APP_NAME=`basename $1`
APP_LABEL=$(echo $APP_NAME | cut -c 1 | tr a-z A-Z)
echo APP_LABEL=$APP_LABEL

#APP_CODE=`echo $APP_NAME | md5sum | sed -e 's| .*||g' | cut -c 1-8`
#echo APP_CODE=$APP_CODE
#APP_CODE=$(( 16#$APP_CODE % 100 ))
#echo APP_CODE=$APP_CODE

if [ ! -d $1 ]; then
   echo Did not find app directory: $1
   exit
fi

if [ -z $2 ]; then
    HUE_CHANGE=100
else
    HUE_CHANGE=$2
fi

mkdir -p $APP_DIR/app/src/main/res/mipmap-xxhdpi
mkdir -p $APP_DIR/app/src/main/res/mipmap-xhdpi
mkdir -p $APP_DIR/app/src/main/res/mipmap-hdpi
mkdir -p $APP_DIR/app/src/main/res/mipmap-mdpi

convert $SCRIPT_DIR/geogram.png \
   -font DejaVu-Sans-Bold \
   -gravity center \
   -pointsize 70 \
   -stroke  none      -fill white       -annotate 0 $APP_LABEL \
   -stroke  '#000094' -strokewidth 10   -annotate 0 $APP_LABEL \
   -stroke  '#000094' -strokewidth 2    -annotate 0 $APP_LABEL \
   $APP_DIR/app/src/main/res/mipmap-xxhdpi/ic_launcher.png

convert -modulate 100,100,$HUE_CHANGE \
	$APP_DIR/app/src/main/res/mipmap-xxhdpi/ic_launcher.png \
	$APP_DIR/app/src/main/res/mipmap-xxhdpi/ic_launcher.png

convert $APP_DIR/app/src/main/res/mipmap-xxhdpi/ic_launcher.png \
        -geometry 48x48 \
	$APP_DIR/app/src/main/res/mipmap-mdpi/ic_launcher.png

convert $APP_DIR/app/src/main/res/mipmap-xxhdpi/ic_launcher.png \
        -geometry 72x72 \
	$APP_DIR/app/src/main/res/mipmap-hdpi/ic_launcher.png

convert $APP_DIR/app/src/main/res/mipmap-xxhdpi/ic_launcher.png \
        -geometry 96x96 \
	$APP_DIR/app/src/main/res/mipmap-xhdpi/ic_launcher.png


eog $APP_DIR/app/src/main/res/mipmap-xxhdpi/ic_launcher.png
