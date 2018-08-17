## loop all files in a folder forever

### Materials
* laptop (with internet connection)
* Raspberry Pi Zero W (or **RPiZeroW**)
* USB Audio Adapter (I use [this](https://www.adafruit.com/product/1475), it's fine / cheap)
* Sound File (**.wav** or **.aiff**)


### Pre-flight

1. **microSD** card prep
2. build **SC** for **RPiZeroW** (steps [here](https://github.com/redFrik/supercolliderStandaloneRPI1))


### Sound File

it would be cool to skip this part idk

**loop_all.scd** can be found [here](https://github.com/caseyanderson/SC3-RPiZeroW/blob/master/fixed_media/loop_all/loop_all.scd)


### similarities between loop_one.scd and loop_all.scd

The long-term goals for **loop_all.scd** are similar to those of  **loop_one.scd**: we want the **RPi** to automatically launch this **SC** file on boot. The following is more or less the same in both files:
* on Line 13 the memory allocated to the `scserver` is increased: `s.options.memSize = 8192 * 4; // adjust multiplier to increase memory`
* on Line 15 `latency` is adjusted: `s.latency= 0.05;`
* on Line 17 the `s.waitForBoot` block begins
* scanning through the rest of the code, one will see two `s.sync` statements


### new techniques from loop_all.scd

The following details new techniques encountered in **loop_all.scd**:
* we start by defining some variables that we will use later: `theDir`, `thePath`, and `bufList`
* on Line 26 we tell `scserver` where our folder full of samples is on the **RPi**. You can check the path to this directory once logged in to your **RPi**: `cd` into the sample folder and run `pwd`.
* on Line 31 we make a `new` `List` object and store it to `bufList`. `Lists` allow us to collect data into one place without having to know ahead of time how much data we will need to store. Here the `List` has a size of 0
