# geogram.android
Scripts and configuration files for compiling geogram applications under Android.

![](https://github.com/BrunoLevy/geogram/wiki/pictures/geobox_android_h.png)


STEP 1: install Android toolchain
---------------------------------
Documentation [here](TOOLCHAIN.md)

STEP 2: get geogram sources
---------------------------
```
$ git clone --recurse-submodules https://github.com/BrunoLevy/geogram.git
```
Optional: get [exploragram](https://github.com/BrunoLevy/exploragram) sources (optimal transport, basic hex meshing)
```
$ cd geogram/src/lib
$ git clone https://github.com/BrunoLevy/exploragram.git
```

STEP 3: get geogram buildsystem for Android
-------------------------------------------
```
$ git clone https://github.com/BrunoLevy/geogram.android.git
```

STEP 4: generate android buildfiles for an app
----------------------------------------------
```
$ geogram.android/Tools/app_make.sh geogram/src/bin/geobox/main.cpp
```
Files are generated in `geogram.android/Apps/geobox`

STEP 5: compile app in debug mode and install on device
-------------------------------------------------------
Compile app in debug mode
```
$ cd geogram.android/Apps/geobox
$ ./gradlew assembleDebug
```
Plug the phone on USB
Install
```
$ adb install -r app/build/outputs/apk/debug/app-debug.apk
```

STEP 6: compile app in release mode and install on device
--------------------------------------------------------
Compile app in release mode
```
$ cd geogram.android/Apps/geobox
$ ./gradlew assembleRelease
```
Sign app (apps compiled in release mode need to be signed, else
they can't be installed on device). Your keystore needs to be
stored in a file `android_keys.keystore` stored in your `$HOME`
directory.
```
$ ../../Tools/app_sign.sh
```
Plug the phone on USB
Install
```
$ adb install -r app/build/outputs/apk/release/app-release-signed.apk
```

Links
-----
[Notes/logbook](NOTES.md)