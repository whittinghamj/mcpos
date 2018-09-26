#!/bin/sh

# preprocessing
# remove BASH colors&codes && \r && empty lines && only last 30 lines
CONSOLE_SHORT_PRE=`cat /mcp/logs/miner.log | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g' | sed 's/\r/\n/g' | grep -a . | tail -n 30`

### bminer
CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | grep -a " Total " | tail -n 1 | sed -e 's/.*Total \(.*\) Accepted.*/\1/'`

echo $CONSOLE_SHORT