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

Get or make a bunch of short **.wav** or **.aiff**'s and put them all in a directory on your **RPi**.


### loop_all.scd

**loop_all.scd** can be found [here](https://github.com/caseyanderson/SC3-RPiZeroW/blob/master/fixed_media/loop_all/loop_all.scd)


#### similarities between loop_one.scd and loop_all.scd

The long-term goals for **loop_all.scd** are similar to those of  **loop_one.scd**: we want the **RPi** to automatically launch this **SC** file on boot. The following is more or less the same in both files:
* on Line 13 the memory allocated to the `scserver` is increased: `s.options.memSize = 8192 * 4;
* on Line 15 `latency` is adjusted: `s.latency= 0.05;`
* on Line 17 the `s.waitForBoot` block begins
* on Line 21 we define some variables that we will use later: `theDir`, `thePath`, and `bufList`
* on Line 26 we assume that the filepath to our directory of samples (`theDir`) will be included as an argument when running the file. We access that information here and store it to `theDir`
* scanning through the rest of the code, one will see two `s.sync` statements


#### new techniques from loop_all.scd

The following details new techniques encountered in **loop_all.scd**:
* on Line 26 we tell `scserver` where our folder full of samples is on the **RPi** (this goes in `theDir`). You can check the path to this directory once logged in to your **RPi**: `cd` into the sample folder and run `pwd`.
* on Line 31 we make a `new` `List` object and store it to `bufList`. `List` allows us to collect and store data without having to know ahead of time how much data we have. Here the `List` has a size of 0 to initialize
* on Line 36 we make a `new` `PathName` object and point it to `theDir`. `PathName` allows us to ask `scserver` to get the full directory [path](https://en.wikipedia.org/wiki/Path_%28computing%29) for us.
* on Line 41 we have a `do` loop which will perform a function for every file in the directory located at `thePath`. More specifically, on line 43 we read through the directory and load each sample into a different `Buffer`. These `Buffers` are stored in `bufList` for usage later. Note that we are **only** reading the left channel (0) in order to insure that we don't accidentally end up  with stereo `Buffers`.
* on Line 52 we convert `bufList` to an `Array`. We don't need to use `List` anymore because we now know how many samples we have in the directory so we may as well convert to a simpler structure
* our SynthDef is on Line 57 and is basically the same as **loop_one.scd** (though here we set `loop` to 0 or False)


### Pbind


### running the file

1. change directories into the `supercolliderStandaloneRPI1`: `cd supercolliderStandaloneRPI1/`
2. run the following command to start **SC**, run the `loop_all.scd` file, and pass the `filepath` information to **SC** as an argument (edit to suit your file structure and file name): `xvfb-run --auto-servernum ./sclang -a -l ~/supercolliderStandaloneRPI1/sclang.yaml /home/pi/SC3-RPiZeroW/fixed_media/loop_all/loop_all.scd /home/pi/uSAMPLES/`


#### autostart.sh

Put the following in `autostart.sh` (edit to suit your situation), run via `cron` (or similar) on boot.

```sh
#!/bin/bash

THE_SCRIPT="/home/pi/SC3-RPiZeroW/fixed_media/loop_all/loop_all.scd"
THE_DIR="/home/pi/uSAMPLES"

./sclang -a -l sclang.yaml $THE_SCRIPT $THE_DIR

```
