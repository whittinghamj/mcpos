#!/bin/bash

echo 'The system is booting, please stand by.'
sleep 2

NVIDIA=`lspci | grep VGA | grep NVIDIA | wc -l`
ATI=`lspci | grep VGA | grep ATI | wc -l`

if [ "$NVIDIA" -gt "0" ]; then
	echo 'NVIDIA GPUs detected, Loading console monitor.'
	sleep 5
    sudo watch -n1 nvidia-smi
    exit 1
fi

if [ "$NVIDIA" -gt "0" ]; then
    echo 'ATI GPUs detected.'
fi