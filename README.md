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
- openmp not directly supported by new SDK, need to say:
```
target_link_libraries(game -fopenmp -static-openmp)
```
- Current state:
   - could compile a version with (legacy) geogram-android "grafted" to endless-tunnel, and it works with OpenMP
   - works also with my own CMakefile now
   - lessons taken:
      - To use open-mp, you need also to add `target_link_libraries(${CMAKE_PROJECT_NAME} -fopenmp -static-openmp)`
      - make sure project name corresponds to dynamic lib loaded by app, declared in `AndroidManifest.xml`,
        meta data `adroid.app.lib_name` (it was one of the problems that made me bang my head against the
        wall)
      - if there is a `CMakeOptions.txt` in geogram that sets intel-only compile flags and sets GEOGRAM_LIB_ONLY to false,
        it confuses Android build !

TODO: resurect my Android platform funcs for ImGui, compare with ImGui's version
(mine has functions to translate keypress, mouse, stylus, multi-finger that may
 not exist in ImGui, to be checked)

Generate a keystore
-------------------
```
$ keytool -genkey -v -keystore mykeystore.keystore -alias myalias -keyalg RSA -keysize 2048 -validity 10000
```

Sign an application
-------------------
```
$ zipalign -v -p 4 app-release-unsigned.apk app-release-signed.apk
$ apksigner sign --ks mykeystore.keystore app-release-signed.apk
$ apksigner verivy app-release-signed.apk
```
(`zipalign` and `apksigner` are in `build-tools`).

LINKS
-----
-[link 1](https://gist.github.com/phlummox/24b488fa8656cf925014639bab9977e5)