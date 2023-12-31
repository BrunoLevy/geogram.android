#!/bin/sh
SCRIPT_DIR=$(dirname "$0")

APP_DIR=$1
APP_LABEL=$2
APP_HUE=$3

if [ ! -d $APP_DIR/app/src/main/res ]; then
   echo did not $APP_DIR/find app/src/main/res
   exit
fi

if [ -z $APP_HUE ]; then
    APP_HUE=100
fi

mkdir -p $APP_DIR/app/src/main/res/mipmap-xxhdpi
mkdir -p $APP_DIR/app/src/main/res/mipmap-xhdpi
mkdir -p $APP_DIR/app/src/main/res/mipmap-hdpi
mkdir -p $APP_DIR/app/src/main/res/mipmap-mdpi

ICON1=$APP_DIR/app/src/main/res/mipmap-xxhdpi/ic_launcher.png

cp $SCRIPT_DIR/geogram.png $ICON1

convert $ICON1 \
   -font DejaVu-Sans-Bold \
   -gravity center \
   -pointsize 70 \
   -stroke  none      -fill white       -annotate 0 $APP_LABEL \
   -stroke  '#000094' -strokewidth 10   -annotate 0 $APP_LABEL \
   -stroke  '#000094' -strokewidth 2    -annotate 0 $APP_LABEL \
   $ICON1

convert -modulate 100,100,$APP_HUE $ICON1 $ICON1

convert $ICON1 \
        -geometry 48x48 \
	$APP_DIR/app/src/main/res/mipmap-mdpi/ic_launcher.png

convert $ICON1 \
        -geometry 72x72 \
	$APP_DIR/app/src/main/res/mipmap-hdpi/ic_launcher.png

convert $ICON1 \
        -geometry 96x96 \
	$APP_DIR/app/src/main/res/mipmap-xhdpi/ic_launcher.png


