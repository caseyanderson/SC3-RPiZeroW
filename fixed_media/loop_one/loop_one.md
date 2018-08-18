## loop one file forever

### Sound File

1. Acquire or locate a **.wav** / **.aiff** file (note: **SC** does not support **MP3** because **MP3** is not [free software](https://en.wikipedia.org/wiki/Free_software))
2. From your laptop, and in the **Terminal**, send the file to the **RPiZeroW**: `scp FILENAME.wav pi@HOSTNAME.local:/home/pi`
3. In the **Terminal** `ssh` to your RPi: `ssh pi@HOSTNAME.local`, enter password


### loop_one.scd

**loop_one.scd** can be found [here](https://github.com/caseyanderson/SC3-RPiZeroW/blob/master/fixed_media/loop_one/loop_one.scd)

The long-term goal is to have the **RPi** automatically launch this **SC** file on boot, which requires some special steps in our code:
* Unless we specify otherwise `scserver` runs with a default amount of memory. Increase the amount of memory `scserver` has access to with something like: `s.options.memSize = 8192 * 4`
* Timing in **SC** is not always exactly precise. In order to manage this one can increase the `latency` (amount of time it takes to do things) on `scserver`. Note that this crucially occurs before the start of `s.waitForBoot` block and is set to `0.05`
* The majority of the code in this file is wrapped in a `s.waitForBoot` [method](https://en.wikipedia.org/wiki/Method_(computer_programming)). `s.waitForBoot` evaluates, or runs, the code between curly brackets as soon as `scserver` has completed booting. We do not know exactly how long it will take for `scserver` to boot so this is an important protective measure
* We could [hardcode](https://en.wikipedia.org/wiki/Hard_coding) the **filepath** to our sample, or we could tell **SC** that it can expect that information when we execute the file (passed in as an argument). `thisProcess.argv`, on Line 20, allows us to access this information and use it in the script. We access the **filepath** on Line 32 with `thePath[0].asString`
* We need to make sure that **SC** waits until `scserver` is done adding our `play` `SynthDef` to the `SynthDescLib` (this is what `.add` does, btw) before trying to use it. In order to do so we include an `s.sync` on line 33. This is kind of like pausing the code until  `scserver` informs `sclang` that it is no longer busy. Since we do not know how long it will take to add `play` to the `SynthDescLib` `s.sync` is a very important tool here.


### running the file

1. change directories into the `supercolliderStandaloneRPI1`: `cd supercolliderStandaloneRPI1/`
2. run the following command to start **SC**, run the `loop_one.scd` file, and pass the `filepath` information to **SC** as an argument (edit to suit your file structure and file name): `xvfb-run --auto-servernum ./sclang -a -l ~/supercolliderStandaloneRPI1/sclang.yaml /home/pi/SC3-RPiZeroW/fixed_media/loop_one/loop_one.scd /home/pi/uSAMPLES/akonting.aif`


#### loop_one.sh

Edit to suit your needs, make the file executable, and launch via `cron` on reboot

```sh
#!/bin/bash

THE_SCRIPT="/home/pi/SC3-RPiZeroW/fixed_media/loop_one/loop_one.scd"
THE_DIR="/home/pi/uSAMPLES"
THE_FILE="akonting.aif"

THE_PATH=$THE_DIR/$THE_FILE

./sclang -a -l sclang.yaml $THE_SCRIPT $THE_PATH

```
