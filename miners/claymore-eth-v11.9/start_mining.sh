#!/bin/bash

location=usa
server=stratum+tcp://cryptonight.$location.nicehash.com:3355
# nanopool
# sudo nohup ./ethdcrminer64 -epool eth-us-west1.nanopool.org:9999 -ewal 0x71e377d4b4125e3c548fb8fe4c06db63f710fbc8.i216368115/admin@deltacolo.com -epsw x -mode 1 -ftime 10 > /mcp/logs/miner.log & 

# nicehash daggerhash
sudo nohup ./ethdcrminer64 -epool $server -ewal 33Z1aVUDJxofRz2QxvjkFnfqtLPifc2nWN.mcpdevus -epsw x -esm 3 -allpools 1 -estale 0 > /mcp/logs/miner.log & 