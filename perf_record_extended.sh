#!/usr/bin/env bash

# usage:
# sh ./perf_record_extended.sh gve (then start gve, records for 15 sec)
# sh ./perf_record_extended.sh gve 30 (then start gve)
# sh ./perf_record_extended.sh fenix 15 home (profiles automatic startup of fenix)
# sh ./perf_record_extended.sh fenix 15 https://google.com/ (profiles automatic applink startup of fenix and browsing to google)

TARGET=$1
COLD_START=1
FRESH_PROFILE=
LAUNCH=
# for applink, set BROWSE_TO (and don't set launch)
BROWSE_TO=$3
DURATION=$2
ACTIVITY=
EXTRA=

if test -n "$DURATION"; then
    DURATION=15
fi

if test "$TARGET" == "fenix"; then
    APP=org.mozilla.fenix.performancetest
else #elif test "$TARGET" == "gve"; then
    APP=org.mozilla.geckoview_example
fi

if test "$TARGET" == "fenix"; then
    if test -n "$BROWSE_TO"; then
	ACTIVITY="-a org.mozilla.fenix.IntentReceiverActivity"
	LAUNCH=1
    else
	ACTIVITY="-a org.mozilla.fenix.HomeActivity"
    fi
else #elif test "$TARGET" == "gve"; then
    if test -n "$BROWSE_TO"; then
	ACTIVITY="-a org.mozilla.geckoview_example.IntentReceiverActivity"
	LAUNCH=1
    else
        ACTIVITY="-a org.mozilla.geckoview_example.GeckoViewActivity"
    fi
fi

# Record a simple perf profile of geckoview_example startup.
#  -Call to app_profiler.py can be customized with simpleperf options
#  -Alternatives code paths launch the app just before the capture begins

if test -n "$COLD_START"; then
  # kill the geckoview processes
  adb shell am force-stop $APP
fi

if test -n "$FRESH_PROFILE"; then
  # optional: fresh profile
  adb shell pm clear $APP
fi

if test -n "$BROWSE_TO"; then
    if test "$BROWSE_TO" != "home"; then
	EXTRA="--target $BROWSE_TO"
    fi
else
    ACTIVITY=
fi 

echo APP = $APP
echo ACTIVITY = $ACTIVITY
echo EXTRA = $EXTRA
echo BROWSE_TO = $BROWSE_TO

# start the simpleperf profile,
# "--call-graph fp" instead of "-g" for arm64 calltrees may work better and support 4000hz sampling

# This copies native libs with debug syms to the phone for perf
# note: if you remove -lib after using it, make sure you remove libs in /data/local/tmp/native_libs/*
# -lib /home/jesup/src/mozilla/inbound_prof/obj-opt/dist/bin
python app_profiler.py -p $APP $ACTIVITY $EXTRA --ndk_path ~/.mozbuild/android-ndk-r17b  -r "-f 1000 -g --duration $DURATION"

# get all the gecko processes (must be running)
#export PIDS=`adb shell ps | grep org.mozilla | cut -c 14-19`
#echo $PIDS
# note: seems to require root
#python app_profiler.py --pid $PIDS --ndk_path ~/.mozbuild/android-ndk-r17b -r "-f 1000 -g --duration $DURATION"
