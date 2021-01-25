#!bin/bash
adb devices
adb shell dumpsys batterystats --enable full-wake-history
adb shell dumpsys batterystats --reset
