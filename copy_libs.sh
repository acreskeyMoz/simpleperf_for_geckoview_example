#!/usr/bin/env bash

# Copy shared objects with symbols from local build to simpleperf binary_cache
: LOCAL_BUILD_PATH ${LOCAL_BUILD_PATH:=/Users/acreskey/dev/firefox/src/build/obj-release-android}
: SIMPLEPERF_PATH ${SIMPLEPERF_PATH:=/Users/acreskey/tools/simpleperf/repo/test_repo/simpleperf/binary_cache/data/app/org.mozilla.geckoview_example-1/lib/arm}

cp $LOCAL_BUILD_PATH/dist/bin/*.so $SIMPLEPERF_PATH
