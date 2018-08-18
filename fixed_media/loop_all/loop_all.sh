#!/bin/bash

THE_SCRIPT="/home/pi/SC3-RPiZeroW/fixed_media/loop_all/loop_all.scd"
THE_SAMPLES="/home/pi/uSAMPLES"

./sclang -a -l sclang.yaml $THE_SCRIPT $THE_SAMPLES
