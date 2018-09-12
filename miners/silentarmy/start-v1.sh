#!/bin/bash

GPU_LIST=`./silentarmy --list | grep -v "Intel" | grep "ID" | awk -F  " " '{print $2}' | awk -F  ":" '{print $1}'`
DEV_SYNTAX=`echo "$GPU_LIST" | awk -vORS=, '{ print $1 }' | sed 's/,$/\n/'`

echo "Starting script for devices: $DEV_SYNTAX"

while true
do
./silentarmy --use $DEV_SYNTAX -c stratum+tcp://$1 -u $2 -p $3
echo "Silentarmy STOPPED !!!!"
sleep 5
done
