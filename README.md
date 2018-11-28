# SC3-RPiZeroW
a collection of SuperCollider3 applications/examples for the Raspberry Pi Zero W

## Pre-flight

This repo assumes that readers are:
* prototyping on a laptop
* deploying to a Raspberry Pi Zero W
* have built supercolliderStandaloneRPI1 as described [here](https://github.com/redFrik/supercolliderStandaloneRPI1)

Note: in many cases these examples will also work on the Raspberry Pi 3 Model B+ with the following caveats:
* readers must have built supercolliderStandaloneRPI2 as described [here](https://github.com/redFrik/supercolliderStandaloneRPI2)
* lines referencing `supercolliderStandaloneRPI1` are edited to reference `supercolliderStandaloneRPI2`


## Materials
* [Raspberry Pi Zero W](https://www.adafruit.com/product/3708)
* [5V 2.5A Switching Power Supply with 20AWG MicroUSB * Cable](https://www.adafruit.com/product/1995)
* [USB OTG Host Cable - MicroB OTG male to A female](https://www.adafruit.com/product/1099) or similar
* [USB Audio Adapter](https://www.adafruit.com/product/1475) or similar
* [SparkFun PiWedge](https://www.sparkfun.com/products/13717) or [Adafruit Pi Cobbler](https://www.adafruit.com/product/2028) (for GPIO)


## Table of Contents
* fixed media
  * [loop_one](https://github.com/caseyanderson/SC3-RPiZeroW/blob/master/fixed_media/loop_one/loop_one.md): loop one sound file forever
  * [loop_all](https://github.com/caseyanderson/SC3-RPiZeroW/tree/master/fixed_media/loop_all): loop all sound files in a directory forever
* OSC
  * [listener](https://github.com/caseyanderson/SC3-RPiZeroW/blob/master/OSC/listener/listener.md): basic OSC communication
  * control synth: control a synth on a different computer
* GPIO
  * [digital input](https://github.com/caseyanderson/SC3-RPiZeroW/blob/master/GPIO/digital_input/digital_input.md): trigger synth creation & playback via Button press (or similar)
  * analog input: control volume of synth via analog sensor input (SPI ADC)
  * analog+digital: trigger synth creation and playback via Button press, control LFO with Analog Sensor (SPI ADC)
