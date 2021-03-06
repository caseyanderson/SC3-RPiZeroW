#!/usr/bin/env python3

'''
Control volume of a synth via analog sensor (SPI ADC)

To Run: python3 analog_input.py --ip "127.0.0.1" --port 57120 --chn 0
'''

from pythonosc import osc_message_builder
from pythonosc import udp_client

from gpiozero import MCP3008

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
        parser.add_argument("--chn", type=int, default=0,
            help="The MCP3008 chn the sensor is on")
        args = parser.parse_args()

        client = udp_client.SimpleUDPClient(args.ip, args.port) # make the client

        sensor = MCP3008(channel=args.chn) # make the sensor object

        print("ready!")

        while True:
            msg = osc_message_builder.OscMessageBuilder(address="/control")
            msg.add_arg("wobble")
            msg.add_arg(sensor.value)
            msg = msg.build()
            client.send(msg)
            sleep(0.05)
    except KeyboardInterrupt:
        print("interrupted!")
        sensor.close()
