#/bin/bash

#purpose: this script can be use to get the report of total band
interface=eth0
community=public
interval=60
server=localhost
clear
echo "\033[0m\033[1m\033[5m@@ Network Interfaces Bandwidth Monitor @@\033[0m"
echo "========================================================="
echo -n "Finding interfaces $interface instance details..."
echo

if [ -z "$1" ]; then
        echo
        echo usage: $0 network-interface
        echo
        echo e.g. $0 eth0
        echo
        exit
fi

IF=$1

while true
do
        R1=`cat /sys/class/net/$1/statistics/rx_bytes`
        T1=`cat /sys/class/net/$1/statistics/tx_bytes`
        sleep 1
        R2=`cat /sys/class/net/$1/statistics/rx_bytes`
        T2=`cat /sys/class/net/$1/statistics/tx_bytes`
        TBPS=`expr $T2 - $T1`
        RBPS=`expr $R2 - $R1`
        TKBPS=`expr $TBPS / 1024`
        RKBPS=`expr $RBPS / 1024`
        echo "Upload $1: $TKBPS kb/s | Download $1: $RKBPS kb/s"
done