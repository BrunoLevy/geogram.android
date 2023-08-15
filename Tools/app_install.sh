#!/bin/sh

APK=app/build/outputs/apk/debug/app-debug.apk

help() {
cat <<EOF
NAME
    app_install.sh

SYNOPSIS
    installs an android geomgram program

USAGE
    app_install.sh [options]

OPTIONS

    -h,-help,--help
        Prints this page.

    -release 
        Installs a release app (default is debug)

    -show-log
        Clears and shows the Android log

    -no-install
        Does not install (to be used with -show-log)
EOF
}

while [ -n "$1" ]; do
    case "$1" in
        -release)
            RELEASE=1
            shift
            ;;
        -show-log)
            SHOW_LOG=1
            shift
            ;;
        -no-install)
            NO_INSTALL=1
            shift
            ;;
        -h | -help | --help)
            shift
            help
            exit
            ;;
        *)
            echo "Error: unrecognized option: $1"
            exit
            ;;
    esac
done

if [ -z $NO_INSTALL ]; then
    if [ ! -z $RELEASE ]; then
        APK=app/build/outputs/apk/release/app-release-signed.apk
    fi

    if [ ! -f $APK ]; then
        echo "Did not find APK:$APK"
        exit
    fi
    echo installing $APK
    adb install -r $APK
fi

if [ ! -z $SHOW_LOG ]; then
    echo "Displaying Android log (<ctrl><C> to exit)"
    adb logcat -c
    adb logcat | grep GEOGRAM
fi
