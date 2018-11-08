#!/usr/bin/env python3

'''


python3 digital_input_GPIO.py --ip "127.0.0.1" --port 57120 --pin 16
'''

from pythonosc import osc_message_builder
from pythonosc import udp_client

from gpiozero import Button

import argparse
import random


if __name__ == '__main__':
    try:
        parser = argparse.ArgumentParser()
        parser.add_argument("--ip", default="127.0.0.1",
            help="The ip of the OSC server")
        parser.add_argument("--port", type=int, default=5005,
            help="The port the OSC server is listening on")
        parser.add_argument("--pin", type=int, default=16,
            help="The GPIO pin the button is on")
        args = parser.parse_args()

        client = udp_client.SimpleUDPClient(args.ip, args.port)
        msg = osc_message_builder.OscMessageBuilder(address="/control")

        button = Button(args.pin)

        prev_val = button.value

        print("ready!")

        while True:
            if button.value == True and button.value != prev_val:
                print("trig synth!")
                msg.add_arg("play")
                msg = msg.build()
                client.send(msg)             
            prev_val = button.value
    except KeyboardInterrupt:
        print("interrupted!")
        button.close()
