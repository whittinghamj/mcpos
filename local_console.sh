#!/bin/bash

NVIDIA=`lspci | grep VGA | grep NVIDIA | wc -l`
ATI=`lspci | grep VGA | grep ATI | wc -l`

if (( $NVIDIA > 0 )); then
    nvidia-smi
fi