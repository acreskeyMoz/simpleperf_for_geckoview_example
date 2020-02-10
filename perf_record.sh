#!/usr/bin/env bash

set -x

# Record a simple perf profile of vehicle startup.
#  -Call to app_profiler.py can be customized with simpleperf options
#  -Alternatives code paths launch the vehicle just before the capture begins

# Fetch unstripped libraries from this directory.
TOPOBJDIR_ARGS=
if [ -d "$TOPOBJDIR" ] ; then
TOPOBJDIR_ARGS=--native_lib_dir $TOPOBJDIR
fi

PACKAGE=org.mozilla.firefox
ACTIVITY=org.mozilla.gecko.BrowserApp

# kill the vehicle processes
adb shell am force-stop $PACKAGE

# optional: fresh profile
adb shell pm clear $PACKAGE

# alternative: launch vehicle just before starting simple perf
#adb shell "am start -n $PACKAGE/$ACTIVITY"

# alternative: launch vehicle to a given site
adb shell "am start -n $PACKAGE/$ACTIVITY -a android.intent.action.VIEW -d 'https://www.google.com'"

# start the simpleperf profile
python app_profiler.py -p $PACKAGE --ndk_path ~/.mozbuild/android-ndk-r20 $TOPOBJDIR_ARGS -r "-f 1000 -g --duration 5"
