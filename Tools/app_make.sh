#!/bin/sh

help() {
cat <<EOF
NAME
    app_make.sh

SYNOPSIS
    creates an Android build tree for a geogram program

USAGE
    app_make.sh geogram/src/.../.../main.cpp [options] 

OPTIONS

    -h,-help,--help
        Prints this page.

    -f
        deletes app build directory if it already exists

    -show_icon
        show generated icon

    -APP_NAME nnn
        specify application name

    -APP_ID id
        specify application id (default: com.inria.geogram.lowercase(APP_NAME))
    
    -APP_LABEL lbl
        label superimposed onto app icon (default: first letter of APP_NAME)

    -APP_HUE hue
        change color of app icon (default: 100 = dark blue)
EOF
}

SCRIPT_DIR=$(dirname "$0")
APP_MAIN_SRC=$1
GEOGRAM_ANDROID_DIR="$SCRIPT_DIR/.."

if [ -z $APP_MAIN_SRC ]; then
    help
    exit
fi

if [ ! -f $APP_MAIN_SRC ]; then
    echo "Did not find main app source"
    echo "usage: app_make.sh path_to_main.cpp"
    exit
fi

APP_NAME=`dirname $APP_MAIN_SRC`
APP_NAME=`basename $APP_NAME`

APP_ID=$(echo $APP_NAME | tr A-Z a-z)
APP_ID=com.inria.geogram.$APP_ID

GEOGRAM_DIR=$(echo "$APP_MAIN_SRC" | sed -e 's|geogram/.*|geogram|')

if [ ! -d $GEOGRAM_DIR ]; then
    echo "Did not find GEOGRAM_DIR: $GEOGRAM_DIR"
    exit
fi

APP_DIR=$GEOGRAM_ANDROID_DIR/Apps/$APP_NAME
APP_LABEL=$(echo $APP_NAME | cut -c 1 | tr a-z A-Z)
APP_HUE=100

shift
while [ -n "$1" ]; do
    case "$1" in
        -f)
            shift
            FORCE=1
            ;;
        -APP_NAME)
            shift
            APP_NAME=$1
            shift
            ;;
        -APP_ID)
            shift
            APP_ID=$1
            shift            
            ;;
        -APP_LABEL)
            shift
            APP_LABEL=$1
            shift            
            ;;
        -APP_HUE)
            shift
            APP_HUE=$1
            shift            
            ;;
        -show_icon)
            SHOW=1
            shift
            ;;
        -h | -help | --help)
            help
            exit
            ;;
        *)
            echo "Error: unrecognized option: $1"
            exit
            ;;
    esac
done


echo Configuration:
echo --------------
echo APP_MAIN_SRC=$APP_MAIN_SRC
echo APP_NAME=$APP_NAME
echo APP_ID=$APP_ID
echo APP_LABEL=$APP_LABEL
echo APP_HUE=$APP_HUE
echo
echo GEOGRAM_DIR=$GEOGRAM_DIR
echo SCRIPT_DIR=$SCRIPT_DIR
echo GEOGRAM_ANDROID_DIR=$GEOGRAM_ANDROID_DIR
echo APP_DIR=$APP_DIR
echo

if [ -d $APP_DIR ]; then
    if [ -z $FORCE ]; then
        echo "$APP_DIR already exists"
        exit
    else
        echo "$APP_DIR existed, but -f specified (clearing it)"
    fi
fi

mkdir -p $APP_DIR
cp -r $SCRIPT_DIR/AppSkeleton/* $APP_DIR
for skel in `find $APP_DIR -name *.skel`
do
    cat $skel | sed \
        -e "s|%APP_MAIN_SRC%|$APP_MAIN_SRC|g" \
        -e "s|%APP_NAME%|$APP_NAME|g" \
        -e "s|%APP_LONG_NAME%|$APP_NAME|g" \
        -e "s|%APP_ID%|$APP_ID|g" \
        -e "s|%GEOGRAM_DIR%|$GEOGRAM_DIR|g" \
    > `dirname $skel`/`basename $skel .skel`
    rm $skel                                                                
done

$SCRIPT_DIR/app_make_icons.sh $APP_DIR $APP_LABEL $APP_HUE

if [ ! -z $SHOW ]; then
    eog $APP_DIR/app/src/main/res/mipmap-xxhdpi/ic_launcher.png
fi

