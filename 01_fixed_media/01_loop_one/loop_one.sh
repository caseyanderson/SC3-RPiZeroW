#!/bin/bash

THE_SCRIPT="/home/pi/SC3-RPiZeroW/01_fixed_media/01_loop_one/loop_one.scd"
THE_DIR="/home/pi/uSAMPLES"
THE_FILE="haiti_baptism.wav"

THE_PATH=$THE_DIR/$THE_FILE

./sclang -a -l sclang.yaml $THE_SCRIPT $THE_PATH
