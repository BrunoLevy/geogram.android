#!/bin/sh
SCRIPT_DIR=$(dirname "$0")
APP_MAIN_SRC=$1
GEOGRAM_ANDROID_DIR="$SCRIPT_DIR/.."

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

echo APP_MAIN_SRC=$APP_MAIN_SRC
echo APP_NAME=$APP_NAME
echo APP_ID=$APP_ID
echo
echo GEOGRAM_DIR=$GEOGRAM_DIR
echo SCRIPT_DIR=$SCRIPT_DIR
echo GEOGRAM_ANDROID_DIR=$GEOGRAM_ANDROID_DIR
echo APP_DIR=$APP_DIR

if [ -d $APP_DIR ]; then
    echo "$APP_DIR already exists"
    exit
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

$SCRIPT_DIR/app_make_icons.sh $APP_DIR

