# Simpleperf for gecko apps
Scripting to make simpleperf profiling of Gecko-based Android Apps easier

You will need to use:
- either a GeckoView-based vehicle from Mozilla that is both
*released* (i.e., has had its full symbols published to
https://symbols.mozilla.org -- generally, Nightly, Beta, or Release)
and has been *debug signed* (i.e., has been processed by
`debug_sign_apk.sh` in this repository);
- or your own `geckoview_example` built from source, i.e., one built
with ``` ./mach build ./mach android install-geckoview_example ```

This is because simpleperf requires the unstripped shared objects
which are not part of the published Android packages directly.

## Setup
- Clone simpleperf:
  - If you want to use symbols from https://symbols.mozilla.org, make
    sure you have the commit at the tip of
    https://github.com/ncalexan/simpleperf/tree/mozilla-symbols, i.e.,
    with
    ```git clone https://github.com/ncalexan/simpleperf && git checkout mozilla-symbols```
  - Otherwise, use the latest prebuilt of simpleperf:
    ```git clone https://android.googlesource.com/platform/prebuilts/simpleperf```

- Add the helper scripts to your clone of the repo
  -  [perf_record.sh](https://github.com/acreskeyMoz/simpleperf_for_geckoview_example/blob/master/perf_record.sh)

- Modify `perf_record.sh` to refer to the correct android-ndk path for
  your workspace and to the correct `$TOPOBJDIR` (if building locally).

- If you are targetting a non-debuggable Mozilla-released vehicle, *debug sign* your
  APK using `debug_sign_apk.sh`.

## Running
- run `perf_record.sh`
  - This will start simpleperf and then wait for geckoview_example to be started manually.
  - In `perf_record.sh` there are alternative codepaths commented out that will launch geckoview_example first and then start profiling
- Once the capture is complete, simpleperf will copy libraries for
  debug info from, in order of preference:
  1. Your `$TOPOBJDIR` (if that environment variable is set)
  2. Mozilla's symbol server at https://symbols.mozilla.org (if you're
  using https://github.com/ncalexan/simpleperf/tree/mozilla-symbols)
  using
  3. The device itself -- although these libraries will be unstripped.
  - simpleperf requires the libraries to be in a specific folder relative to the data file. e.g `binary_cache/data/app/org.mozilla.geckoview_example-1/lib/arm/libxul.so`
  - **Depending on the device and app** you may need to manually copy the unstripped libs to the correct `binary_cache` folder,  e.g. ```binary_cache/data/app/org.mozilla.fenix.debug-cGBgD0-yu6fZrNrmK2DHpw==/lib/arm```
  - You can ensure that they are unstripped by running `file` on them, e.g. `file binary_cache/data/app/org.mozilla.geckoview_example-1/lib/arm/libxul.so`

- You can then run `python report_html.py` to generate the html report

- There are additional scripts which can be useful such as the `report.py` or `report_sample.py`.
  - Note that these scripts require you to explicitly set the symbol path.
  - e.g.  `python report.py --sort dso --symfs binary_cache` or `python report_sample.py --symfs binary_cache`

## Exporting to firefox profiler format
- Randell has made modifications to the simpleperf script `report_sample.py` to export to a format consumable by [profiler.firefox.com](https://profiler.firefox.com).
- Usage: `python report_sample_gecko.py --symfs binary_cache > firefox.data` and then load `firefox.data` into [profiler.firefox.com](https://profiler.firefox.com).
- e.g. [pageload of reddit](https://perfht.ml/2Vfxs6t)


## Notes
- The script `perf_record_extended.sh` has been added which also provides options to capture applink, fenix, and other variations
- Simpleperf is a rich tool with many more options, described [here](https://android.googlesource.com/platform/system/extras/+/master/simpleperf/doc/README.md)
- From the simpleperf tooling: "app_profiler.py isn't supported on Android < N, please switch to use
                        simpleperf binary directly."

