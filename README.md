# Simpleperf for geckoview_example
Scripting to make simpleperf profiling of geckoview_example easier

You will need to build your own geckoview_example from source.
This is because simpleperf requires the unstripped shared objects which are not kept as build artifacts.

## Setup
- Clone the latest prebuilt of simpleperf:
  - ```git clone https://android.googlesource.com/platform/prebuilts/simpleperf```

- Add the helper scripts to your clone of the repo
  -  [copy_libs.sh](https://github.com/acreskeyMoz/simpleperf_for_geckoview_example/blob/master/copy_libs.sh)
  -  [perf_record.sh](https://github.com/acreskeyMoz/simpleperf_for_geckoview_example/blob/master/perf_record.sh)

- Modify `copy_libs.sh` so that the paths `LOCAL_BUILD_PATH` and `SIMPLEPERF_PATH` match your workspace

- Modify `perf_record.sh` to refer to the correct android-ndk path for your workspace

## Running
- run `perf_record.sh` 
  - This will start simpleperf and then wait for geckoview_example to be started manually.
  - In `perf_record.sh` there are alternative codepaths commented out that will launch geckoview_example first and then start profiling

- Once the capture is complete, you will need to copy your unstripped libraries over by running `copy_libs.sh` (as it is, simpleperf will copy the stripped libs right from the android device)
  - simpleperf requires the libraries to be in a specific folder relative to the data file. e.g `binary_cache/data/app/org.mozilla.geckoview_example-1/lib/arm/libxul.so`
  - After running `copy_libs.sh` verify that the libraries you compiled have been copied to the simpleperf `binary_cache` folder for your app.
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
- Simpleperf is a rich tool with many more options, described [here](https://android.googlesource.com/platform/system/extras/+/master/simpleperf/doc/README.md)
- From the simpleperf tooling: "app_profiler.py isn't supported on Android < N, please switch to use
                        simpleperf binary directly."

