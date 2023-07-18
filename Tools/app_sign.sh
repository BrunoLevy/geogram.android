
# specify keystore and Android tools path here
KEYSTORE=$HOME/android_keys.keystore
TOOLS_PATH=/home/blevy/Programming/Android/build-tools/30.0.3

if [ ! -f $KEYSTORE ]; then
  echo did not find keystore $KEYSTORE
  exit
fi

SOURCE=app/build/outputs/apk/release/app-release-unsigned.apk
TARGET=app/build/outputs/apk/release/app-release-signed.apk

if [ ! -f $SOURCE ]; then
cat << END
      Did not find target ($SOURCE)
      app_sign.sh must be run in app source directory
END
   exit
fi

rm -f $TARGET
$TOOLS_PATH/zipalign -v -p 4 $SOURCE $TARGET
$TOOLS_PATH/apksigner sign --ks $KEYSTORE $TARGET
$TOOLS_PATH/apksigner verify $TARGET

