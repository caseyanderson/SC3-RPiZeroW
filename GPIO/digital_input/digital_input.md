## digital input

### Reference

* [Open Sound Control](http://opensoundcontrol.org/)
* [OSC Communication](http://doc.sccode.org/Guides/OSC_communication.html) (from the SC3 docs)
* [gpiozero](https://gpiozero.readthedocs.io/en/stable/#)


### Materials
* SPST Button or similar


### Pre-Flight

* [gpiozero](https://gpiozero.readthedocs.io/en/stable/installing.html): `sudo apt install python3-gpiozero`


### Hookup Pattern (RPi)

Your button should have four pins. Using only one side, connect one pin to `GND` and the other to `G13`.


### run the example

1. make both files executable: `sudo chmod +x trigSynthDtrm.py` (RPi) and `sudo chmod +x trigSynthDtrm.scd` (laptop)
2. run the SC file (on your laptop)
3. run the Python file (on your RPi): `python3 send_osc.py --ip "LAPTOPIPADDRESS" --pin 13`

If everything worked properly you should be able to trigger new instances of a `Synth` with every button press.


### trigSynthDtrm.scd

Some quick notes about new techniques from this file:

* the `SynthDef` `\sin` a uses a deterministic envelope (`Env.linen`) which will clean itself up when complete. This enables us to send an arbitrary amount of triggers to create an arbitrary amount of `Synth`s (limited only by the memory of our laptop [or RPi])
* IRand is a Ugen that returns random Integers within a range and is here used to randomly play different partials of a fundamental pitch (the latter is set by `freq`)
* the `OSCdef` uses a switch to compare the incoming message (`msg[1]`) to messages the SC file can respond to. If `sineResponder` receives the message `[ /control, play ]` it will create and play a new instance of `\sin` for a duration of 4 seconds. Note that this `OSCdef` could respond to `[ /control, vol ]` if `send_osc.py` used it.


### trigSynthDtrm.py



Note the following:

* blah

Note the following:
* we use `argparse` here to both set defaults as well as provide a command line interface. In this case the arguments are `--ip`, with a default of `127.0.0.1`, and `--port`, with a default of `57120`. If one is sending to a **different** computer one would need to provide that computer's `IP Address` like so: `python3 send_osc.py --ip "IPADDRESS"`
* we create a `upd_client` object, store it at `client`, and then pass the `ip` and `port` for our message destination to it
* finally, a `for` loop is used to send ten random numbers to the destination
