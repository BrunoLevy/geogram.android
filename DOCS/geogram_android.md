# Geogram under android, architectural notes

Geogram's support for Android is based on several components

Application
-----------
Geogram's android applications are pure NDK (Native Development Kit) apps, that is,
without a single line of Java, like some mobile games. To develop it, I started
by an example in the [NDK samples](https://github.com/android/ndk-samples.git) that
is also a pure NDK app (`endless-tunnel`). 

Operating system helper functions
---------------------------------

Unfortunately, some parts of Android are written in Java, such as the functions for:

- showing/hiding the virtual keyboard
- convert a keycode to a unicode character
- check whether a permission was granted (such as reading or writing
  to external storage, for instance the `Downloads` directory)
- request a permission. You need to do that to let the user check the little box
  letting geogram apps read and writ files in the `Downloads` directory for instance.
- getting the directory where temporary files can be stored

The good news is that one can call any Java function from C (or C++) using a quite horrible
but complete API (JNI for Java Native Interface). Using it, I wrote code 
for these four functionalities
[geogram/basic/android_utils.h](https://github.com/BrunoLevy/geogram/blob/main/src/lib/geogram/basic/android_utils.h),
[geogram/basic/android_utils.cpp](https://github.com/BrunoLevy/geogram/blob/main/src/lib/geogram/basic/android_utils.cpp).
The documentation is [here](https://brunolevy.github.io/geogram/android__utils_8h.html). If you take a look
at [geogram/basic/android_utils.cpp](https://github.com/BrunoLevy/geogram/blob/main/src/lib/geogram/basic/android_utils.cpp),
you will see that JNI code is quite horrible !

Graphic user interface
----------------------

[Dear Imgui](https://github.com/ocornut/imgui) is fantastically well written, with a clear separation between
the logic, the rendering code, and some OS-specific functions. Android supports OpenGL ES 3, so there is already
rendering code for ImGui. For the other OS-specific functions, there is now a `imgui_impl_android.h/.cpp` in
the backends shipped with ImGui. At the time I started, it did not exist, so mine is in
`geogram/src/lib/geogram_gfx/ImGui_ext`. It has a couple of additional function to support multiple fingers,
stylus, keyboard, and to properly convert the typed character using the keymap (which uses one of the
JNI functions in `android_utils` mentioned in the previous section). TODO: make my updates compatible with
the official backend.

Since a phone usually has a small screen with a (ridiculously high) resolution, the default setting and layout
of the GUI components are completely different as compared to geogram "desktop mode". It uses two functionalities
of Dear ImGui:
- its ability to draw scaled vector fonts (and we use a huge font)
- its ability to serialize/unserialize the state of all the windows. So we have a precompiled serialized GUI
  state for vertical and horizontal phone apps, and we can even dynamically swap them whenever the user flips
  his phone !

To ease development of phone apps, the desktop version of geogram can behave as if it was running on the phone,
by specifying the `phone=true` argument on the command line. And one can resize the window to simulate a
portrait-landscape phone flip and see how the GUI reacts.

3D graphics
-----------

Geogram has a [GLUP](https://brunolevy.github.io/geogram/GLUP_8h.html) library, that reimplements the OpenGL 2
fixed functionality pipeline in OpenGL 3 (using VBOs, VAOs and shaders) plus volumetric primitives plus
some functionalities (computing normals, drawing mesh outline, picking). Since OpenGL ES v3 is supported on
Android, GLUP rendering code directly works.

In OpenGL, there is also some glue code for creating a context, and this glue code is different in Android.
For other OSes, it is taken care of by [GLFW](https://www.glfw.org/). For Android, it is some custom code.
All this is implemented in the [Application](https://brunolevy.github.io/geogram/classGEO_1_1Application.html#details)
class.

Building Android apps
---------------------

Android build system needs a complicated collection of files (gradle configuration, Android manifest, resources).
In our case they are (nearly) always the same, so they are generated from a skeleton, adapted to each individual
app by replacing a couple of strings. Most of this is implemented in the
[Tools/app_make.sh](https://github.com/BrunoLevy/geogram.android/blob/main/Tools/app_make.sh) script.
