#!/bin/bash

NVIDIA=`lspci | grep VGA | grep NVIDIA | wc -l`
ATI=`lspci | grep VGA | grep ATI | wc -l`

if[ $NVIDIA > 0]
then
	echo 'NVIDIA DETECTED'
	sleep 5
	nvidia-smi
	exit 1
else

fi