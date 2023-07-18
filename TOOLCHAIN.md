# install Android toolchain

STEP 1: Installing Android development tools
--------------------------------------------
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

STEP 2: Set Android developper mode on phone
--------------------------------------------
1) Settings -> About phone
2) Scroll down to build number
3) Tap build number seven times
4) Enable developper options

STEP 3: Compiling an example app (optionnal)
--------------------------------------------
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

STEP 4: Generate a keystore
---------------------------
```
$ keytool -genkey -v -keystore mykeystore.keystore -alias myalias -keyalg RSA -keysize 2048 -validity 10000
```

How to sign an application
--------------------------
```
$ zipalign -v -p 4 app-release-unsigned.apk app-release-signed.apk
$ apksigner sign --ks mykeystore.keystore app-release-signed.apk
$ apksigner verivy app-release-signed.apk
```
(`zipalign` and `apksigner` are in `build-tools`).
