#!/bin/bash

echo 'The system is booting, please stand by.'
sleep 2
echo " "

echo "#########################################"
echo "Checking connection to Internet..."
i=0
while [ "$i" -le 6 ]; do
  # timeout 10 works about 20 seconds :)
  CZY=`host -W 10 -t SOA miningcontrolpanel.com | grep -ci "miningcontrolpanel.com"`
  if [ "$CZY" -gt 0 ]; then
    echo "Internet OK."
    break
  fi
  i=$((i+1))
  echo "Probing"
done
echo "#########################################"
sleep 2
echo " "


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