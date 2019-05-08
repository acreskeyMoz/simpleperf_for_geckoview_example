#!/usr/bin/env bash

# Copy shared objects with symbols from local build to simpleperf binary_cache
: LOCAL_BUILD_PATH ${LOCAL_BUILD_PATH:=/Users/acreskey/dev/firefox/src/build/obj-release-android}
: SIMPLEPERF_PATH ${SIMPLEPERF_PATH:=/Users/acreskey/tools/simpleperf/repo/test_repo/simpleperf/binary_cache/data/app/org.mozilla.geckoview_example-1/lib/arm}

cp $LOCAL_BUILD_PATH/toolkit/library/*.so $SIMPLEPERF_PATH
cp $LOCAL_BUILD_PATH/dist/bin/libmozglue.so $SIMPLEPERF_PATH
cp $LOCAL_BUILD_PATH/dist/bin/libnssckbi.so $SIMPLEPERF_PATH
cp $LOCAL_BUILD_PATH/security/libnss3.so $SIMPLEPERF_PATH
cp $LOCAL_BUILD_PATH/security/nss/lib/softoken/softoken_softokn3/libsoftokn3.so $SIMPLEPERF_PATH
cp $LOCAL_BUILD_PATH/security/nss/lib/freebl/freebl_freebl3/libfreebl3.so $SIMPLEPERF_PATH
