#!/bin/bash

HASHRATE="$(sh /mcp/stats.sh)";
UPTIME="$(uptime)";

echo " "
echo "System Health: $UPTIME"

echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "Internet Connection: Online"
else
    echo "Internet Connection: Offline"
fi

echo "Miner Hashrate: $HASHRATE"

echo " "

sudo nvidia-smi