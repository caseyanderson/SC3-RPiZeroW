## loop all files in a folder forever

### Sound File

Get or make a bunch of short **.wav** or **.aiff**'s and put them all in a directory on your **RPi**.


### loop_all.scd

**loop_all.scd** can be found [here](https://github.com/caseyanderson/SC3-RPiZeroW/blob/master/fixed_media/loop_all/loop_all.scd)


#### similarities between loop_one.scd and loop_all.scd

The long-term goals for **loop_all.scd** are similar to those of  **loop_one.scd**: we want the **RPi** to automatically launch this **SC** file on boot. The following is more or less the same in both files:
* on Line 13 the memory allocated to the `scserver` is increased: `s.options.memSize = 8192 * 4;`
* on Line 15 `latency` is adjusted: `s.latency= 0.05;`
* on Line 17 the `s.waitForBoot` block begins
* on Line 21 we define some variables that we will use later: `theDir`, `thePath`, and `bufList`
* on Line 26 we assume that the filepath to our directory of samples (`theDir`) will be included as an argument when running the file. We access that information here and store it to `theDir`
* scanning through the rest of the code, one will see two `s.sync` statements


#### new techniques unique to loop_all.scd

The following details new techniques encountered in **loop_all.scd**:
* on Line 26 we tell `scserver` where our folder full of samples is on the **RPi** (this goes in `theDir`). You can check the path to this directory once logged in to your **RPi**: `cd` into the sample folder and run `pwd`.
* on Line 31 we make a `new` `List` object and store it to `bufList`. `List` allows us to collect and store data without having to know ahead of time how much data we have. Here the `List` has a size of 0 to initialize
* on Line 36 we make a `new` `PathName` object and point it to `theDir`. `PathName` allows us to ask `scserver` to get the full directory [path](https://en.wikipedia.org/wiki/Path_%28computing%29) for us.
* on Line 41 we have a `do` loop which will perform a function for every file in the directory located at `thePath`. More specifically, on line 43 we read through the directory and load each sample into a different `Buffer`. These `Buffers` are stored in `bufList` for usage later. Note that we are **only** reading the left channel (0) in order to insure that we don't accidentally end up  with stereo `Buffers`.
* on Line 52 we convert `bufList` to an `Array`. We don't need to use `List` anymore because we now know how many samples we have in the directory so we may as well convert to a simpler structure
* our SynthDef is on Line 57 and is basically the same as **loop_one.scd** (though here we set `loop` to 0 or False)


### Pbind

Note: [this](http://doc.sccode.org/Tutorials/A-Practical-Guide/PG_01_Introduction.html) is a great guide about Patterns in SC (by H. James Harkins)

* on Line 73 we affiliate our `Pbind` `~sample_player` with the `SynthDef` it will control via `\instrument`
* Line 74 uses `Pxrand` to randomly choose `Buffer` objects from `~buffers`, allowing us to randomly select a new sample every time `Pbind` triggers a new instance of the `Synth`
* Line 75 uses a `Pfunc` to get the duration (in seconds) of whichever sample is randomly selected by `Pxrand` (in the previous line) and sets the duration of the `Env` to that value
* Line 79 sets `\delta` to the duration of the chosen sample, which effectively means that a new sample will not begin playing until the previous one is finished


### running the file

1. change directories into the `supercolliderStandaloneRPI1`: `cd supercolliderStandaloneRPI1/`
2. run the following command to start **SC**, run the `loop_all.scd` file, and pass the `filepath` information to **SC** as an argument (edit to suit your file structure and file name): `xvfb-run --auto-servernum ./sclang -a -l ~/supercolliderStandaloneRPI1/sclang.yaml /home/pi/SC3-RPiZeroW/fixed_media/loop_all/loop_all.scd /home/pi/uSAMPLES/`


#### loop_all.sh

1. Edit `loop_all.sh` to suit your needs

```sh
#!/bin/bash

THE_SCRIPT="/home/pi/SC3-RPiZeroW/fixed_media/loop_all/loop_all.scd"
THE_DIR="/home/pi/uSAMPLES"

./sclang -a -l sclang.yaml $THE_SCRIPT $THE_DIR

```

2. make the file executable: `sudo chmod +x loop_all.sh`
3. open up `cron`: `crontab -e`
4. scroll to the bottom of the file and add the following: `@reboot cd /home/pi/supercolliderStandaloneRPI2 && xvfb-run sh /home/pi/SC3-RPiZeroW/fixed_media/loop_all/loop_all.sh`
5. reboot to hear `loop_all.sh` start everything up
