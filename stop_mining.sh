#!/bin/bash
COUNT=`ps aux | grep '/mcp/miners' | awk '{print $2}' | wc -l`
COUNT=$COUNT + 1
sudo kill $(ps aux | grep '/mcp/miners' | awk '{print $2}') > /dev/null 2>&1
sudo kill $(ps aux | grep 'start_mining.sh' | awk '{print $2}') > /dev/null 2>&1

echo 'Terminating $COUNT mining processes.'