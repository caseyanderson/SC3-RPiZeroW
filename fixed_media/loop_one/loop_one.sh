#!/bin/bash

THE_SCRIPT="/home/pi/SC3-RPiZeroW/fixed_media/loop_one/loop_one.scd"
THE_SAMPLE="/home/pi/uSAMPLES/akonting.aif"

./sclang -a -l sclang.yaml $THE_SCRIPT $THE_SAMPLE
