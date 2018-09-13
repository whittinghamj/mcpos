#!/bin/bash

# get last 15 lines of the log file
CONSOLE=`cat /mcp/logs/miner.log | sed 's/\r/\n/g' | grep -a . | tail -n 15 | aha --no-header`
# replace [space & < > " ' '] with underscore
CONSOLE=`echo "$CONSOLE" | sed 's/&nbsp;/_/g; s/&amp;/_/g; s/&lt;/_/g; s/&gt;/_/g; s/&quot;/_/g; s/&ldquo;/_/g; s/&rdquo;/_/g;'`
# remove amp
CONSOLE=`echo "$CONSOLE" | sed 's/\&//g' | tr '"' "'"`

echo $CONSOLE

CONSOLE_SHORT_PRE=`cat /mcp/logs/miner.log | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g' | sed 's/\r/\n/g' | grep -a . | tail -n 30`

echo " "

echo $CONSOLE_SHORT_PRE