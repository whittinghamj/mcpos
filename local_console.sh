#!/bin/bash

HASHRATE="$(sh /mcp/stats.sh)";
UPTIME="$(uptime | sed -E 's/^[^,]*up *//; s/, *[[:digit:]]* users.*//; s/min/minutes/; s/([[:digit:]]+):0?([[:digit:]]+)/\1 hours, \2 minutes/' )";

echo " "
echo "System Uptime: $UPTIME"

echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "Internet Connection: Online"
else
    echo "Internet Connection: Offline"
fi

echo "Miner Hashrate: $HASHRATE"

echo " "

sudo nvidia-smi