#!/bin/bash

UPTIME=`uptime -p`
KERNEL_VERSION=`uname -r`

FINAL_GPU_TEMP=`cat /var/tmp/stats_gpu_temp`
FINAL_GPU_FANSPEED=`cat /var/tmp/stats_gpu_fanspeed`
FINAL_GPU_CORE=`cat /var/tmp/stats_gpu_core`
FINAL_GPU_MEMORY=`cat /var/tmp/stats_gpu_memory`
FINAL_GPU_COUNT=`cat /var/tmp/stats_gpu_count 2>/dev/null`
FINAL_GPU_MODEL=`cat /var/tmp/stats_gpu_model 2>/dev/null`

# get last 15 lines of the log file
CONSOLE=`cat /mcp/logs/miner.log | sed 's/\r/\n/g' | grep -a . | tail -n 15 | aha --no-header`
# replace [space & < > " ' '] with underscore
CONSOLE=`echo "$CONSOLE" | sed 's/&nbsp;/_/g; s/&amp;/_/g; s/&lt;/_/g; s/&gt;/_/g; s/&quot;/_/g; s/&ldquo;/_/g; s/&rdquo;/_/g;'`
# remove amp
CONSOLE=`echo "$CONSOLE" | sed 's/\&//g' | tr '"' "'"`

CONSOLE_SHORT_PRE=`cat /mcp/logs/miner.log | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g' | sed 's/\r/\n/g' | grep -a . | tail -n 30`

CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | grep -a " Total " | tail -n 1 | sed -e 's/.*Total \(.*\) Accepted.*/\1/'`

echo $CONSOLE_SHORT

echo $CONSOLE_SHORT | awk '{print $5" "$6}'