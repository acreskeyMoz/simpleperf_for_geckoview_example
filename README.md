# Simpleperf for geckoview
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

## Running
- run `perf_record.sh` 
  - This will start simpleperf and then wait for geckoview_example to be started manually.
  - In `perf_record.sh` there are alternative codepaths commented out that will launch geckoview_example first and then start profiling

- Once the capture is complete, you can copy your unstripped libraries over by running `copy_libs.sh` (as it is, simpleperf will copy the stripped libs right from the android device)

- You can then run `python report_html.py` to generate the html report

- Alternatively you can use the `report.py` script.  `python report.py --sort dso --symfs binary_cache`

## Notes
- Simpleperf is a rich tool with many more options, described [here](https://android.googlesource.com/platform/system/extras/+/master/simpleperf/doc/README.md)
- From the simpleperf tooling: `app_profiler.py isn't supported on Android < N, please switch to use
                        simpleperf binary directly.`

