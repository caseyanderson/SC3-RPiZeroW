#!/usr/bin/env python3

'''
python sends osc message to sc

TO RUN: python3 sender_osc.py RECEIVER_IP RECEIVER_PORT
i.e. python3 send_osc.py --ip "127.0.0.1" --port 57120

this python module https://github.com/attwad/python-osc
installed from pip3: $ pip3 install python-osc
'''

import argparse
import random
import time

from pythonosc import osc_message_builder
from pythonosc import udp_client


if __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument("--ip", default="127.0.0.1",
      help="The ip of the OSC server")
  parser.add_argument("--port", type=int, default=5005,
      help="The port the OSC server is listening on")
  args = parser.parse_args()

  client = udp_client.SimpleUDPClient(args.ip, args.port)

  for x in range(10):
    client.send_message("/control", random.random())
    time.sleep(1)
