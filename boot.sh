#!/bin/bash

rm -rf /mcp/*.loc
rm -rf /mcp/logs/*

touch /mcp/logs/console.log
touch /mcp/logs/deamon.log
touch /mcp/logs/miner.log

export DISPLAY=:0
export GPU_MAX_ALLOC_PERCENT=100
export GPU_USE_SYNC_OBJECTS=1
export GPU_SINGLE_ALLOC_PERCENT=100
export GPU_MAX_HEAP_SIZE=100
export GPU_FORCE_64BIT_PTR=1

# screen -S miner -X logfile /mcp/logs/miner.log 1>/dev/null 2>/dev/null