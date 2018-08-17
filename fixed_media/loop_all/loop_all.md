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


### loop_all.scd

**loop_all.scd** can be found [here](https://github.com/caseyanderson/SC3-RPiZeroW/blob/master/fixed_media/loop_all/loop_all.scd)

Again, similar goals to **loop_one.scd**: we want the **RPi** to automatically launch this **SC** file on boot. The following is basically the same as **loop_one.scd**:
* on Line 13 the memory allocated to the `scserver` is increased: `s.options.memSize = 8192 * 4; // adjust multiplier to increase memory`
* on Line 15 latency is adjusted: `s.latency= 0.05;`
* on Line 17 the `s.waitForBoot` block begins
* scanning through the rest of the code, one will see 2x `s.sync` statements, which tells the interpreter to wait until the `scserver` is done processing the previous code before proceeding
