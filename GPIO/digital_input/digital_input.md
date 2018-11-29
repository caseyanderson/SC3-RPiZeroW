## digital input

### Reference

* [Open Sound Control](http://opensoundcontrol.org/)
* [OSC Communication](http://doc.sccode.org/Guides/OSC_communication.html) (from the SC3 docs)
* [gpiozero](https://gpiozero.readthedocs.io/en/stable/#)


### Materials
* SPDT Button or similar


### Pre-Flight

* [gpiozero](https://gpiozero.readthedocs.io/en/stable/installing.html): `sudo apt install python3-gpiozero`


### Hookup Pattern (RPi)

Your button should have four pins. Using only one side, connect one pin to `GND` and the other to `G13`.


### run the example

1. make both files executable: `sudo chmod +x trigSynthDtrm.py` (RPi) and `sudo chmod +x trigSynthDtrm.scd` (laptop)
2. run the SC file (on your laptop)
3. run the Python file (on your RPi): `python3 send_osc.py --ip "LAPTOPIPADDRESS" --pin 13`

If everything worked properly you should be able to trigger a new instance of a `Synth` with every button press.


### trigSynthDtrm.scd

`trigSynthDtrm.scd` can be found [here](trigSynthDtrm.scd). Some quick notes about new techniques from this file:

* the `SynthDef` `\sin` a uses a deterministic envelope (`Env.linen`) which will clean itself up when complete. This enables us to send an arbitrary amount of triggers to create an arbitrary amount of `Synth`s (limited only by the memory of our laptop [or RPi])
* `IRand` is a `Ugen` that returns random `integers`, within a range, and is here used to randomly play different partials of a fundamental pitch (the latter is set by `freq`)
* the `OSCdef` uses a `switch` to compare the incoming message (`msg[1]`) to messages the SC file can respond to (`switch` is kind of like an `if` with a series of `elif` statements). If the `sineResponder` receives the message `[ /control, play ]` it will create and play a new instance of `\sin` for a duration of 4 seconds with a random partial of some fundamental. Note that this `OSCdef` could respond to `[ /control, vol ]` if `send_osc.py` used it, but volume control is not implemented in `send_osc.py`


### trigSynthDtrm.py

`trigSynthDtrm.py` can be found [here](trigSynthDtrm.py). Some quick notes about new techniques from this file:

* we have an additional argument: `--pin` is used to set the `GPIO` pin for the button. It defaults to `G16`, though here I am using `G13`
* the button interface is handled via `gpiozero`. We create a button object and then check its value before entering a `while` loop. The assumption is that the `button.value` will be `False` (not pressed) most of the time
* the loop handles two tasks: 1. check `button.value` and check to see if `button.value` is different than the previous state (stored at `prev_val`). If `button.value` is `True` **and** is different than the `prev_val` a button press is detected, which sends a "play" message to `trigSynthDtrm.scd`
* the last line of the `while` loop crucially contains a `sleep` statement: `sleep(0.05)`, causing the program to pause for an extremely short amount of time, preventing memory issues and randomly missed button presses
