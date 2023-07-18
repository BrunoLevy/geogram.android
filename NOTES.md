# Notes on Android development


Installing CMake 3.6.0
----------------------
```
  $ ./sdkmanager --sdk_root=/home/blevy/Programming/Android/ --install "cmake;3.6.4111459"
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

LINKS
-----
-[link 1](https://gist.github.com/phlummox/24b488fa8656cf925014639bab9977e5)
