# geogram.android
Scripts and configuration files for compiling geogram applications under Android.
WIP, for now, just my notes.

Installing Android development tools
------------------------------------
1) install android SDK command line tools from [website](https://developer.android.com/studio)
```
  $ mkdir <install directory>
  $ cd <install directory>
  $ unzip commandlinetools-linux-nnn_latest.zip
  $ cd cmdline-toolstools/bin
```   
2) accept licenses
```
  $ ./sdkmanager --sdk_root=/home/blevy/Programming/Android/ --licenses
```  
3) install NDK
```
  $ ./sdkmanager --sdk_root=/home/blevy/Programming/Android/ ndk-bundle
```   
4) install platform tools
```
  $ ./sdkmanager --sdk_root=/home/blevy/Programming/Android/ platform-tools
```  
5) install CMake 3.6.0
```
  $ ./sdkmanager --sdk_root=/home/blevy/Programming/Android/ --install "cmake;3.6.4111459"
```
6) set `ANDROID_SDK_ROOT`
Add to `.bashrc`:
```
   export ANDROID_SDK_ROOT=<install directory>
```   

Set Android developper mode on phone
------------------------------------
1) Settings -> About phone
2) Scroll down to build number
3) Tap build number seven times
4) Enable developper options

Compiling an example app
------------------------
1) get NDK samples
```
$ git clone https://github.com/android/ndk-samples.git
```
2) compile an example
```
$ cd ndk-samples/endless-tunnel
$ ./gradlew assembleDebug
```
3) send to device
```
$ adb install app/build/outputs/apk/debug/app-debug.apk
```

Fixing warnings in example app
------------------------------
When compiling the example app, there were two annoying warnings in CMake. How to fix them:
- edit `app/src/main/cpp/CMakeLists.txt`, add `project(endless_tunnel)` right after `cmake_minimum_version`
- edit `app/build.gradle`, in the second instance of `externalNativeBuild` (that is, *not* in `defaultConfig`),
  add `version "3.22.1"` right before `path`

Morphing demo app to GeoBox
---------------------------
- prepend `$ANDROID_SDK_ROOT/cmake/3.6.4111459/bin` to `$PATH`
- edit `app/build.gradle`
   `namespace 'com.inria.pixel.geobox'`
- edit `app/src/AndroidManifest.xml`
   - permissions
   - configChanges
   - android.app.lib_name
- `app/src/main/res`
- `app/src/main/cpp`

TODO: resurect my Android platform funcs for ImGui
