# Notes on Android development

How to installing CMake 3.6.0
-----------------------------
(not needed, but just in case...)
```
  $ ./sdkmanager --sdk_root=/home/blevy/Programming/Android/ --install "cmake;3.6.4111459"
```

Fixing warnings in example app
------------------------------
When compiling the example app, there were two annoying warnings in CMake. How to fix them:
- edit `app/src/main/cpp/CMakeLists.txt`, add `project(endless_tunnel)` right after `cmake_minimum_version`
- edit `app/build.gradle`, in the second instance of `externalNativeBuild` (that is, *not* in `defaultConfig`),
  add `version "3.22.1"` right before `path`

What was blocking
-----------------
- Needed to rewrite gradle configuration files, several things have changed (I do not understand what).
  Re-starting from a [NDK examples](https://github.com/android/ndk-samples.git) demo that resembles
  what we want to do is a good idea (`endless-tunnel` is a pure NDK app, without any Java)
- `app/build.gradle`, in the second instance of `externalNativeBuild` (that is, *not* in `defaultConfig`),
  add `version "3.22.1"` right before `path`. Else it uses `CMake` from the NDK (version 3.18.1) that seems
  to lack some features used by `geogram`
- make sure the shared object name in `app/src/main/AndroidManifest.xml` and the actual built shared object
  match
- keep `android:exported="true"` in activity flags (still in `AndroidManifest.xml`). I set it to false, but
  then when I click on the icon, it says "application not found"
- if there is a `CMakeOptions.txt` in geogram that sets intel-only compile flags and sets `GEOGRAM_LIB_ONLY`
  to false, it confuses Android build !


Logbook: what I did to "morph" the `endless-tunnel` demo to GeoBox
------------------------------------------------------------------
- prepend `$ANDROID_SDK_ROOT/cmake/3.6.4111459/bin` to `$PATH` (not useful in fact if CMake version
  set in `build.gradle`)
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

TODO: for now, it is using my own `imgui_impl_android.h/.cpp` in `geogram_gfx/ImGui_ext`. Try
to use the one that is now shipped with `imgui` (or at least, start by copying it, and insert
the new stuff in it, that is, function to translate keypress, mouse, stylus, multi-finger that may
not exist in ImGui, to be checked.

LINKS
-----
-[link 1](https://gist.github.com/phlummox/24b488fa8656cf925014639bab9977e5)
