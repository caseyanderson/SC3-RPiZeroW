## loop one file forever

### Materials
* laptop (with internet connection)
* Raspberry Pi Zero W (or **RPiZeroW**)
* Sound File (**.wav** or **.aiff**)

### Pre-flight

1. **microSD** card prep
2. build **SC3** for **RPiZeroW** (steps [here](https://github.com/redFrik/supercolliderStandaloneRPI1))


### Sound File

1. Acquire or locate a **.wav** / **.aiff** file (note: SC3 does not support **MP3** because **MP3** is not [free software](https://en.wikipedia.org/wiki/Free_software))
2. From your laptop, and in the **Terminal**, send the file to the **RPiZeroW**: `scp FILENAME.wav pi@HOSTNAME.local:/home/pi`
3. In the **Terminal** `ssh` to your RPi: `ssh pi@HOSTNAME.local`, enter password


### loop_one.scd

The **loop_one.scd** can be found [here](../blob/master/fixed_media/scripts/loop_one.scd)

We eventually want the RPi to launch this SC file on boot, which means we need to do some things differently than one would on their laptop:
* unless we specify otherwise, the SC server runs with a default amount of memory. Increase the amount of memory the SC Server has access to with something like: `s.options.memSize = 8192 * 4`
* Timing in SC is not always exactly precise and. In order to manage this one can increase the `latency` (amount of time it takes to do things) on the `Server`. Note that this occurs before the `s.waitForBoot` line and is currently set to `0.05`
* The majority of the code in this file is wrapped in a `s.waitForBoot` method. `s.waitForBoot` evaluates, or runs, the code between curly brackets as soon as the `Server` has completed booting. We do not know exactly how long it will take for the Server to boot so this is an important protective measure

Timing complications don't stop once the Server finishes booting.
