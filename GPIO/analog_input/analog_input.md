## analog input

### Reference

* [Open Sound Control](http://opensoundcontrol.org/)
* [OSC Communication](http://doc.sccode.org/Guides/OSC_communication.html) (from the SC3 docs)
* [gpiozero](https://gpiozero.readthedocs.io/en/stable/#)


### Materials
* MCP3008 (SPI ADC)
* Light Dependent Resistor (or other Voltage Divider)
* 10K Resistor


### Pre-Flight

* [gpiozero](https://gpiozero.readthedocs.io/en/stable/installing.html): `sudo apt install python3-gpiozero`
* enable `SPI`:
  * `sudo raspi-config`
  * select `Interfacing Options`, hit ENTER
  * select `SPI`, hit ENTER
  * select `Yes`, hit ENTER
  * select `OK`, hit ENTER
  * select `Finish`, hit ENTER


### Hookup Pattern

| MCP3008 Pin # | MCP3008 Pin Function | PiCobbler Pin # | PiWedge Pin # |
|-------|--------|--------|--------|
| 16 | VDD | 3.3V | 3.3V |
| 15 | VREF | 3.3V | 3.3V |
| 14 | AGND | GND | GND |
| 13 | CLCK | SCLCK | SCK |
| 12 | DOUT | MISO | MISO |
| 11 | DIN | MOSI | MOSI |
| 10 | CS/SHDN | CE0 | CE0 |
| 9 | GND | GND | GND |


### run the example

1. make both files executable: `sudo chmod +x analog_input.py` (RPi) and `sudo chmod +x analog_input.scd` (laptop)
2. run the SC file (on your laptop)
3. run the Python file (on your RPi): `python3 analog_input.py --ip "LAPTOPIPADDRESS"`

If everything worked properly you should be able to change the frequency of an LFO by increasing or decreasing the amount of light hitting the `LDR`.


### analog_input.scd

`analog_input.scd` can be found [here](analog_input.scd). A quick note about a new techniques from this file:

* in the `\sinResponder` we scale the `wobble` frequency number from its original range (`0.0` to `1.0`) to the desired range (`0.1` to `10`) with `.linlin`, an object in SC which can convert numbers from one range to another. We store the scaled value to `val` for use elsewhere.


### analog_input.py

`analog_input.py` can be found [here](analog_input.py). Some quick notes about new techniques from this file:

* we create a `sensor` object on line 32 and tell it which `MCP3008` channel to use
* at the top of our `while` loop we create an `osc_message_builder` object, give it a label (`/control`) to begin every message with.
* next we build the rest of our message, argument by argument, with two `msg.add_arg`s: one for "wobble" and one for the `sensor_value`. Our full message will look something like `[/control, wobble, 0.2]`
* in the next two lines we build the msg, with `msg.build()`, and send it to our `client` with `client.send(msg)`. Note: our `client` could be the same RPi, in which case the `IP` would be `127.0.0.1` (in fact, that's the default for `--ip`), or a different device on the same WIFI network
