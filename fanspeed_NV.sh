#!/bin/bash

CONFIG_FILE="/root/config.txt"
source $CONFIG_FILE

ocTempTarget=60
ocFanSpeedMin=20

ocTempTargetUser=`echo $JSON | jq -r .ocTempTarget`
ocFanSpeedMinUser=`echo $JSON | jq -r .ocFanSpeedMin`

# Overclocking
if [ $osSeries != "NV" ]; then
    exit
fi

if [ "$ocTempTargetUser" -ge 30  ] && [ "$ocTempTargetUser" -le 85 ]; then
    ocTempTarget="$ocTempTargetUser"
fi

if [ "$ocFanSpeedMinUser" -ge 20  ] && [ "$ocFanSpeedMin" -le 100 ]; then
    ocFanSpeedMin="$ocFanSpeedMinUser"
fi

FANS=(`nvidia-smi -a | grep -i fan | sed 's/[^0-9]*//g'`)

x=0
for ITEM in `nvidia-smi -q -d TEMPERATURE | grep "Current" | sed 's/[^0-9]*//g'`
do

    FAN_UP_STEP=2
    FAN_DOWN_STEP=1
    GPU_TEMP="$ITEM"
    GPU_FAN="${FANS[$x]}"

    DIFF=`echo "$((ocTempTarget-GPU_TEMP))" | sed 's/-//g'`

if [ $DIFF -ge 7 ]; then
    FAN_UP_STEP=100
    FAN_DOWN_STEP=1
elif [ $DIFF -ge 5 ]; then
    FAN_UP_STEP=25
    FAN_DOWN_STEP=1
elif [ $DIFF -ge 4 ]; then
    FAN_UP_STEP=15
    FAN_DOWN_STEP=1
elif [ $DIFF -ge 3 ]; then
    FAN_UP_STEP=5
    FAN_DOWN_STEP=1
elif [ $DIFF -ge 2 ]; then
    FAN_UP_STEP=3
    FAN_DOWN_STEP=1
elif [ $DIFF -ge 1 ]; then
    FAN_UP_STEP=2
    FAN_DOWN_STEP=1
elif [ $DIFF -ge 0 ]; then
    FAN_UP_STEP=0
    FAN_DOWN_STEP=0
fi

NEW_GPU_FAN=$(( GPU_FAN ))

if [ $GPU_TEMP -gt $((ocTempTarget)) ]; then
    NEW_GPU_FAN=$(( GPU_FAN + FAN_UP_STEP ))
    echo "1nowy gpu fan speed: $NEW_GPU_FAN"
fi
if [ $GPU_TEMP -lt $((ocTempTarget-1)) ]; then
    NEW_GPU_FAN=$(( GPU_FAN - FAN_DOWN_STEP ))
    echo "2nowy gpu fan speed: $NEW_GPU_FAN"
fi

if [ $NEW_GPU_FAN -le $ocFanSpeedMin ]; then
    NEW_GPU_FAN=$ocFanSpeedMin
    echo "3nowy gpu fan speed: $NEW_GPU_FAN"
fi

if [ $NEW_GPU_FAN -ge 100 ]; then
    NEW_GPU_FAN=100
    echo "4nowy gpu fan speed: $NEW_GPU_FAN"
fi

DISPLAY=:0 nvidia-settings -a "[gpu:$x]/GPUFanControlState=1" -a "[fan:$x]/GPUTargetFanSpeed=$NEW_GPU_FAN"
echo "temp:$GPU_TEMP diff:$DIFF fan speed:$GPU_FAN -> $NEW_GPU_FAN"
#echo "----------"

x=$((x+1))
done
sudo chvt 1 &
