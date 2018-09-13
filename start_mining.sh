#!/bin/bash

# get worker name

# pid / lock file


# miner
sudo nohup /mcp/miners/claymore-eth-v11.9/ethdcrminer64 -epool stratum+tcp://daggerhashimoto.eu.nicehash.com:3353 -ewal 33Z1aVUDJxofRz2QxvjkFnfqtLPifc2nWN.mcpdevus -epsw x -esm 3 -allpools 1 -estale 0 -dpool stratum+tcp://decred.eu.nicehash.com:3354 -dwal 33Z1aVUDJxofRz2QxvjkFnfqtLPifc2nWN.mcpdevus > /mcp/logs/miner.log & 

# /mcp/miners/silentarmy/silentarmy --use 0 -c stratum+tcp://us1-zcash.flypool.org:3333 -u t1dAGBEwP6jJVqRozRUMTp4EUzeMosAHeQz