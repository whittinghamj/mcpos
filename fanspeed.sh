#!/bin/bash

# flock
set -e
scriptname=$(basename $0)
pidfile="/var/lock/${scriptname}"
exec 200>$pidfile
flock -n 200 || exit 1
pid=$$
echo $pid 1>&200
set +e

CONFIG_FILE="/root/config.txt"
source $CONFIG_FILE

# Overclocking
if [ $osSeries == "RX" ]; then
    /root/utils/fanspeed_RX.sh
elif [ $osSeries == "R" ]; then
    su - miner /root/utils/fanspeed_R.sh
elif [ $osSeries == "NV" ]; then
    su - miner /root/utils/fanspeed_NV.sh
fi
