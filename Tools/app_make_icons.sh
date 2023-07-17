#!/bin/sh
scriptdir=$(dirname "$0")

if [ ! -d app/src/main/res ]; then
   echo did not find app/src/main/res
   echo app_make_icons.sh should be run in app source directory
   exit
fi

if [ -z $1 ]; then
   echo Missing label
   exit
fi

if [ -z $2 ]; then
    HUE_CHANGE=100
else
    HUE_CHANGE=$2
fi

mkdir -p app/src/main/res/mipmap-xxhdpi
mkdir -p app/src/main/res/mipmap-xhdpi
mkdir -p app/src/main/res/mipmap-hdpi
mkdir -p app/src/main/res/mipmap-mdpi

convert ../tools/Generic/app/src/main/res/mipmap-xxhdpi/ic_launcher.png \
   -font DejaVu-Sans-Bold \
   -gravity center \
   -pointsize 70 \
   -stroke  none      -fill white       -annotate 0 $1 \
   -stroke  '#000094' -strokewidth 10   -annotate 0 $1 \
   -stroke  '#000094' -strokewidth 2    -annotate 0 $1 \
   $scriptdir/ic_launcher.png

convert -modulate 100,100,$HUE_CHANGE \
	app/src/main/res/mipmap-xxhdpi/ic_launcher.png \
	app/src/main/res/mipmap-xxhdpi/ic_launcher.png

convert app/src/main/res/mipmap-xxhdpi/ic_launcher.png \
        -geometry 48x48 \
	app/src/main/res/mipmap-mdpi/ic_launcher.png

convert app/src/main/res/mipmap-xxhdpi/ic_launcher.png \
        -geometry 72x72 \
	app/src/main/res/mipmap-hdpi/ic_launcher.png

convert app/src/main/res/mipmap-xxhdpi/ic_launcher.png \
        -geometry 96x96 \
	app/src/main/res/mipmap-xhdpi/ic_launcher.png


eog app/src/main/res/mipmap-xxhdpi/ic_launcher.png
