#!/bin/bash

export DISPLAY=:0
export GPU_MAX_ALLOC_PRECENT=100
export GPU_USE_SYNC_OBJECTS=0
export GPU_SINGLE_ALLOC_PERCENT=100

# nanopool
# sudo nohup ./ethdcrminer64 -epool eth-us-west1.nanopool.org:9999 -ewal 0x71e377d4b4125e3c548fb8fe4c06db63f710fbc8.i216368115/admin@deltacolo.com -epsw x -mode 1 -ftime 10 > /mcp/logs/miner.log & 

# nicehash daggerhash
cd /mcp/miners/claymore-eth-v11.9
sudo nohup ./ethdcrminer64 -epool stratum+tcp://daggerhashimoto.usa.nicehash.com:3353 -ewal 33Z1aVUDJxofRz2QxvjkFnfqtLPifc2nWN.mcpdevus -epsw x -esm 3 -allpools 1 -estale 0 -dpool stratum+tcp://decred.eu.nicehash.com:3354 -dwal 33Z1aVUDJxofRz2QxvjkFnfqtLPifc2nWN.mcpdevus > /mcp/logs/miner.log & 