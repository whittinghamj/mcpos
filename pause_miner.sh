#!/bin/bash

while /bin/true; do
	echo 'Miner is in pause mode' >> /mcp/logs/console.log
    ## killall -9 miners > /dev/null
    sudo kill $(ps aux | grep 'miners' | awk '{print $2}') > /dev/null 2>&1
    sleep 5
done &
