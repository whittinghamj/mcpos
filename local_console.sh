#!/bin/bash

NVIDIA=`lspci | grep VGA | grep NVIDIA | wc -l`
ATI=`lspci | grep VGA | grep ATI | wc -l`

if [ "$NVIDIA" -gt "0" ]; then
	echo 'The system is booting, please stand by.'
	sleep 5
    sudo watch -n1 nvidia-smi
fi