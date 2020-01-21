#!/usr/bin/env bash

# Make a release-signed Fennec APK debuggable for `simpleperf`.
#
# Run this script in your Gecko topsrcdir, so that
# [`mobile/android/debug_sign_tool.py`](https://searchfox.org/mozilla-central/source/mobile/android/debug_sign_tool.py)
# exists.
#
# You need to have [`apktool`](https://ibotpeaches.github.io/Apktool/)
# and the standard Java tools `keytool` and `jarsigner` on your path.

set -x

RELEASE="$1"
DEBUG="debug_sign_apk.apk"

# First, we need an AndroidManifest.xml with
# android:debuggable="true".  This is a lot of effort for just that,
# but it works.

apktool d -f -o debug_sign_apk $RELEASE

apktool b -d debug_sign_apk -o $DEBUG

# Why not just use the APK that apktool produces?  Because all of the
# resources get processed, which could impact performance.  Better to
# manually update our original APK "surgically".  This keeps changes
# to a minimum, including the order of files in the underlying APK.

python mobile/android/debug_sign_tool.py --keytool=`which keytool` --jarsigner=`which jarsigner` $DEBUG

unzip -o $DEBUG AndroidManifest.xml
unzip -o $DEBUG 'META-INF/*'

mv META-INF/ANDROIDD.SF META-INF/SIGNATURE.SF 
mv META-INF/ANDROIDD.RSA META-INF/SIGNATURE.RSA

cp $RELEASE $DEBUG

zip $DEBUG -u AndroidManifest.xml
zip $DEBUG -u META-INF/*

echo "Now 'adb install $DEBUG' and 'adb shell run-as org.mozilla.firefox' to verify android:debuggable=\"true\"."

# Clean up.
rm -rf AndroidManifest.xml META-INF debug_sign_apk
