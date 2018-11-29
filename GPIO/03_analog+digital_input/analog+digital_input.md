## analog+digital input

### Reference

* [Open Sound Control](http://opensoundcontrol.org/)
* [OSC Communication](http://doc.sccode.org/Guides/OSC_communication.html) (from the SC3 docs)
* [gpiozero](https://gpiozero.readthedocs.io/en/stable/#)


### Materials
* MCP3008 (SPI ADC)
* SPDT Button
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

1. make both files executable: `sudo chmod +x analog+digital_input.py` (RPi) and `sudo chmod +x analog+digital_input.scd` (laptop)
2. run the SC file (on your laptop)
3. run the Python file (on your RPi): `python3 analog+digital_input.py --ip "LAPTOPIPADDRESS" --pin 13`

If everything worked properly you should be able to trigger synth creation and playback via Button press and also control LFO frequency via analog sensor input.


### analog+digital_input.scd

`analog+digital_input.scd` can be found [here](analog+digital_input.scd). A quick note about a new techniques from this file:

* on Line 10 we create a Control Bus (`Bus.control`) and store it to `~sens1`, a global variable. This will enable many synths to share the same control information, in this case the value from the `LDR`.
* the `SynthDef` `\sin` is a `SinOsc` capable of playing partials of some fundamental with an `LFO`. `DelayN` is used here to randomly delay changes to the sensor value, the data source for `wobble` frequency, resulting in a slightly different `wobble` rate for every sounding or future `Synth`
* `\listener` can respond to two different OSC messages: `play` and `wobble`, both of which are handled by `switch`. If a message starts with `play` `\listener` will create and play a new instance of synth `\sin`, using the current value from the `LDR` to set `wobble` frequency. If a message starts with `wobble` the value will be passed to the Control Bus at `~sens1`, simultaneously updating the `wobble` rate of any sounding synths (if there are any) and storing the value at `~sens1` (for use later). Note that `msg[2]` is scaled via `.linlin` and then stored to `val` for convenience throughout


### analog+digital_input.py

`analog+digital_input.py` can be found [here](analog+digital_input.py). One quick note about this file:

* our `while` loop formats the OSC message based on `button.value`. More specifically, if a button press is detected (`button.value == True and button.value != prev_val`) trigger synth playback and pass `sensor.value` to the `\listener`. If a button press is not detected (`button.value == False`) only send `sensor.value` to the `\listener`. Whether we make a new synth instance or not we control the `wobble` time of any sounding or future synth via `sensor.value`

Note: our `client` could be the same RPi, in which case the `IP` would be `127.0.0.1` (in fact, that's the default for `--ip`), or a different device on the same WIFI network
