#!/bin/bash
TOTAL=`ps aux | grep '/mcp/miners' | awk '{print $2}' | wc -l`
TOTAL='$TOTAL + 1' | bc
sudo kill $(ps aux | grep '/mcp/miners' | awk '{print $2}') > /dev/null 2>&1
sudo kill $(ps aux | grep 'start_mining.sh' | awk '{print $2}') > /dev/null 2>&1

echo 'Terminating $TOTAL mining processes.'