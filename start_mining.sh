#!/bin/bash


# pid / lock file
mypidfile=/mcp/start_mining.pid
trap "rm -f -- '$mypidfile'" EXIT
echo $$ > "$mypidfile"


# nvidia vars
export GPU_FORCE_64BIT_PTR=0
export GPU_MAX_HEAP_SIZE=100
export DISPLAY=:0
export GPU_MAX_ALLOC_PRECENT=100
export GPU_USE_SYNC_OBJECTS=0
# export GPU_USE_SYNC_OBJECTS=1
export GPU_SINGLE_ALLOC_PERCENT=100


# miner
sudo nohup /mcp/miners/claymore-eth-v11.9/ethdcrminer64 -epool stratum+tcp://daggerhashimoto.eu.nicehash.com:3353 -ewal 33Z1aVUDJxofRz2QxvjkFnfqtLPifc2nWN.mcpdevus -epsw x -esm 3 -allpools 1 -estale 0 -dpool stratum+tcp://decred.eu.nicehash.com:3354 -dwal 33Z1aVUDJxofRz2QxvjkFnfqtLPifc2nWN.mcpdevus > /mcp/logs/miner.log & 


# /mcp/miners/silentarmy/silentarmy --use 0 -c stratum+tcp://us1-zcash.flypool.org:3333 -u t1dAGBEwP6jJVqRozRUMTp4EUzeMosAHeQz