#!/bin/bash

THE_SCRIPT="/home/pi/SC3-RPiZeroW/fixed_media/loop_one/loop_one.scd"
THE_DIR="/home/pi/uSAMPLES"
THE_FILE="akonting.aif"

THE_PATH=$THE_DIR/$THE_FILE

./sclang -a -l sclang.yaml $THE_SCRIPT $THE_PATH
