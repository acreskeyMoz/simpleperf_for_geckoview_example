#!/usr/bin/env bash

# Record a simple perf profile of geckoview_example startup.
#  -Call to app_profiler.py can be customized with simpleperf options
#  -Alternatives code paths launch the app just before the capture begins

# kill the geckoview processes
adb shell am force-stop org.mozilla.geckoview_example

# optional: fresh profile
adb shell pm clear org.mozilla.geckoview_example

# alternative: launch geckoview just before starting simple perf
#adb shell 'am start -n org.mozilla.geckoview_example/org.mozilla.geckoview_example.GeckoViewActivity'

# alternative: launch geckoview example to a given site
#adb shell 'am start -n org.mozilla.geckoview_example/org.mozilla.geckoview_example.GeckoViewActivity -a android.intent.action.VIEW -d https://www.google.com'

# start the simpleperf profile
python app_profiler.py -p org.mozilla.geckoview_example --ndk_path ~/.mozbuild/android-ndk-r17b -r "-f 1000 -g --duration 5"
