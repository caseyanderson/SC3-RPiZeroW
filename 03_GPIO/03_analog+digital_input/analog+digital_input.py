#!/usr/bin/env python3

'''
Trigger synth instances via button press, control "wobble time" via analog sensor (SPI ADC)

To Run: python3 analog+digital.py --ip "127.0.0.1" --port 57120 --pin 27 --chn 0
'''

from pythonosc import osc_message_builder
from pythonosc import udp_client

from gpiozero import MCP3008
from gpiozero import Button

import argparse
import random
from time import sleep


if __name__ == '__main__':
    try:
        parser = argparse.ArgumentParser()
        parser.add_argument("--ip", default="127.0.0.1",
            help="The ip of the OSC server")
        parser.add_argument("--port", type=int, default=57120,
            help="The port the OSC server is listening on")
        parser.add_argument("--pin", type=int, default=16,
            help="The GPIO pin the button is on")
        parser.add_argument("--chn", type=int, default=0,
            help="The MCP3008 chn the sensor is on")
        args = parser.parse_args()

        client = udp_client.SimpleUDPClient(args.ip, args.port) # make the client
        button = Button(args.pin) # make the button object
        sensor = MCP3008(channel=args.chn) # make the sensor object

        prev_val = button.value

        print("ready!")

        while True:
            if button.value == True and button.value != prev_val:
                print("trig synth!")
                msg = osc_message_builder.OscMessageBuilder(address="/control")
                msg.add_arg("play")
                msg.add_arg("wobble")
                msg.add_arg(sensor.value)
                msg = msg.build()
                client.send(msg)
            elif button.value == False:
                msg = osc_message_builder.OscMessageBuilder(address="/control")
                msg.add_arg("wobble")
                msg.add_arg(sensor.value)
                msg = msg.build()
                client.send(msg)
            prev_val = button.value
            sleep(0.05)
    except KeyboardInterrupt:
        print("interrupted!")
        button.close()
