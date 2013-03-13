webos_dalvik
============

Yet another attempt to run the Android Dalvik VM on WebOS 3.0.5 using the offical WebOS PDK.

I am targeting a pretty vanilla Ubuntu 10 install, mostly because I will be
stealing things out of the android source tree (like core.jar) eventually, and
I want to be "officially" building Android correctly.

I'm also only targeting the webOS 3.0.5 PDK, rather than Open webOS for now,
because I think it will be easer to go forward to Open webOS, than backwards
to 3.0.5.

It's also important to remember not to commit any changes to the submodule
repositories. We don't want to interrupt any of the Android work flow, and we
also don't want to commit anything to our source that depends on changing
upstream Android source. To that effect, make sure you always test your cmake
build after running:
$ git submodule foreach git clean -f -d
$ git submodule foreach git checkout .
This shouldn't be required the very first time you checkout/clone the repo, but
running CMake even once will create symlinks that aren't part of the upstream
repositories.

Build with cmake like you would any other project:
$ mkdir <source dir> && cd <source dir>
$ git clone --recursive https://github.com/kai4785/webos_dalvik.git
$ mkdir <build dir> && cd <build dir>
$ cmake -DCMAKE_BUILD_TYPE=Debug <source dir>/webos_dalvik
$ make -j`lscpu | awk '/^CPU\(s/{print $2}'`
$ make DESTDIR=. install

At this point, your build directory should have a com.kai.dalvikvm directory with a 'bin' and 'lib' directory containing stuff.
I don't have a way to build core.jar yet, so I steal it from an Android Source build. On my machine it's:
<android source dir>/out/target/product/generic/dex_bootjars/system/framework/core.jar
Copy these jar files into a new directory com.kai.dalvikvm/framework:
$ mkdir com.kai.dalvikvm/framework
$ cp <android source dir>/out/target/product/generic/dex_bootjars/system/framework/{core,ext,framework,bouncycastle}.jar com.kai.dalvikvm/framework

Don't have one of your own? Here, have one of mine:
$ wget -O com.kai.dalvikvm/framework/core.jar http://kai.gnukai.com/framework_4.0.4/core.jar
$ wget -O com.kai.dalvikvm/framework/ext.jar http://kai.gnukai.com/framework_4.0.4/ext.jar
$ wget -O com.kai.dalvikvm/framework/framework.jar http://kai.gnukai.com/framework_4.0.4/framework.jar
$ wget -O com.kai.dalvikvm/framework/bouncycastle.jar http://kai.gnukai.com/framework_4.0.4/bouncycastle.jar

Now we need the icu data file: (FIXME This should be done in CMake....)
$ mkdir com.kai.dalvikvm/icu
$ cp <source dir>/external/icu4c/stubdata/icudt46l-all.dat com.kai.dalvikvm/icu/icudt46l.dat

$ palm-package com.kai.dalvikvm
$ palm-install com.kai.dalvikvm*.ipk

With the ipk installed, you're almost ready. First, create a dalvik-cache directory, and cd to the applications directory
# mkdir /media/internal/dalvik-cache

Next, get a jar file to test. Here, have one of mine:
# mkdir /media/internal/android-jars/
# wget -O /media/internal/android-jars/CmdLine.jar http://kai.gnukai.com/CmdLine.jar

Now, cd here to shorten some of the copy-paste text, set a few environmental variables, and fire off the command:
# cd /media/cryptofs/apps/usr/palm/applications
# export ANDROID_ROOT=$PWD/com.kai.dalvikvm
# export ANDROID_DATA=/media/internal
# export LD_LIBRARY_PATH=com.kai.dalvikvm/lib
# export FRAMEWORK=$PWD/com.kai.dalvikvm/framework
# export BOOTCLASSPATH=$FRAMEWORK/core.jar:$FRAMEWORK/ext.jar:$FRAMEWORK/framework.jar:$FRAMEWORK/bouncycastle.jar

# ./com.kai.dalvikvm/bin/dalvikvm -classpath /media/internal/android-jars/CmdLine.jar org.apache.HelloWorld

The first time it runs, it will take a moment to create the dex cache files in /media/internal/dalvik-cache, so don't panic if it takes 3-5 seconds before it does anything.

If all went well, you should be staring at the output:
Hello World!


Next steps:
Teach CMake how to create the java libraries for dalvik (ie core.jar)

Run the dalvik test suite in dalvik/tests on the webOS device. Since there's no sun javac for webOS, we'll probably have to pre-compile all the java files and run them through 'dx' before attempting to run them on the TouchPad.

Zygote
http://coltf.blogspot.com/p/android-os-processes-and-zygote.html
http://elinux.org/Android_Zygote_Startup
This requires running app_process, which is the program that initializes all of the system libraries, like graphics, audio, ect.
The bulk of that work is from the library 'android_runtime'. We need to decide how much of 'android_runtime' we use, and how much we just do ourselves. 
This is where the *real* porting work is.

In order to allow builds for dalvikvm to continue to work with out interruption, I've put all the app_process work inside an if(WEBOS_RUNTIME) block in the main CMakeLists.txt. If you want to see how ap_process is progressing, you'll want to add "-DWEBOS_RUNTIME=True" to your cmake line. The output on the TouchPad should look promising.

# mkdir /var/socket
# ./com.kai.dalvikvm/bin/app_process -Xzygote /system/bin --zygote --start-system-server
Created socket '/var/socket/zygote' with mode '1232', user '0', group '0'
I/SamplingProfilerIntegration( 8011): Profiling disabled.
I/Zygote  ( 8011): Preloading classes...

But what's it doing? And how do I kick it to do more?
http://stackoverflow.com/questions/5494764/how-to-run-a-specific-android-app-using-terminal
./frameworks/base/cmds/am/am
Looks like a good place to start!
# export CLASSPATH=$PWD/com.kai.dalvikvm/framework/am.jar
# $ANDROID_ROOT/bin/app_process $ANDROID_ROOT com.android.commands.am.Am "$@"
