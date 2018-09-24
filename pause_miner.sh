#!/bin/bash

while /bin/true; do
	echo 'Miner is in pause mode' >> /mcp/logs/console.log
    killall -9 miners > /dev/null
    sleep 5
done &
