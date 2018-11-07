#!/usr/bin/env python3

'''


'''

from pythonosc import osc_message_builder
from pythonosc import udp_client


from gpiozero import Button
from gpiozero import LED

import argparse
import random


if __name__ == '__main__':
    try:
        parser = argparse.ArgumentParser()
        parser.add_argument("--ip", default="127.0.0.1",
            help="The ip of the OSC server")
        parser.add_argument("--port", type=int, default=5005,
            help="The port the OSC server is listening on")
        args = parser.parse_args()

        client = udp_client.SimpleUDPClient(args.ip, args.port)

        button = Button(16)

        prev_val = button.value

        print("ready!")

        while True:
            if button.value == True and button.value != prev_val:
                print("trig synth!")
                client.send_message("/control", random.random())
            prev_val = button.value
    except KeyboardInterrupt:
        print("interrupted!")
        button.close()
