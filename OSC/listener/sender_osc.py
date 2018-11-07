#!/usr/bin/env python3

'''
python sends osc message to sc

arg1 is RECEIVER_IP
arg2 is RECEIVER_PORT

TO RUN: python3 sender_osc.py RECEIVER_IP RECEIVER_PORT
i.e. python3 sender_osc.py "127.0.0.1" 57120

this python module https://github.com/attwad/python-osc
installed from pip3: $ pip3 install python-osc
'''

from pythonosc import osc_message_builder
from pythonosc import udp_client
import random
import time
import sys

RECEIVER_IP = str(sys.argv[1])
RECEIVER_PORT =  int(sys.argv[2])

client = udp_client.SimpleUDPClient(RECEIVER_IP, RECEIVER_PORT)
client.send_message("/control", random.random())
