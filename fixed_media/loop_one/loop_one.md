## loop one file forever

### Materials
* laptop (with internet connection)
* Raspberry Pi Zero W (or **RPiZeroW**)
* Sound File (**.wav** or **.aiff**)

### Pre-flight

1. **microSD** card prep
2. build **SC** for **RPiZeroW** (steps [here](https://github.com/redFrik/supercolliderStandaloneRPI1))


### Sound File

1. Acquire or locate a **.wav** / **.aiff** file (note: **SC** does not support **MP3** because **MP3** is not [free software](https://en.wikipedia.org/wiki/Free_software))
2. From your laptop, and in the **Terminal**, send the file to the **RPiZeroW**: `scp FILENAME.wav pi@HOSTNAME.local:/home/pi`
3. In the **Terminal** `ssh` to your RPi: `ssh pi@HOSTNAME.local`, enter password


### loop_one.scd

**loop_one.scd** can be found [here](../blob/master/fixed_media/scripts/loop_one.scd)

The long-term goal is to have the **RPi** automatically launch this **SC** file on boot, which requires some special steps in our code:
* Unless we specify otherwise, the `Server` runs with a default amount of memory. Increase the amount of memory the `Server` has access to with something like: `s.options.memSize = 8192 * 4`
* Timing in **SC** is not always exactly precise. In order to manage this one can increase the `latency` (amount of time it takes to do things) on the `Server`. Note that this crucially occurs before the start of `s.waitForBoot` block and is set to `0.05`
* The majority of the code in this file is wrapped in a `s.waitForBoot` [method](https://en.wikipedia.org/wiki/Method_(computer_programming)). `s.waitForBoot` evaluates, or runs, the code between curly brackets as soon as the `Server` has completed booting. We do not know exactly how long it will take for the `Server` to boot so this is an important protective measure
* We need to make sure that **SC** waits until the `Server` is done adding our `play` `SynthDef` to the `SynthDescLib` (this is what `.add` does, btw) before trying to use it. In order to do so we include an `s.sync` on line 33. This is kind of like pausing the code until  `scserver` informs the `sclang` that it is no longer busy. Since we do not know how long it will take to add `play` to the `SynthDescLib` `s.sync` is a very important tool here.
