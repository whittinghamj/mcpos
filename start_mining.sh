#!/bin/bash

# get worker name

# pid / lock file


# claymore-eth-v11.9
sudo nohup /mcp/miners/claymore-eth-v11.9/ethdcrminer64 -epool stratum+tcp://daggerhashimoto.eu.nicehash.com:3353 -ewal 33Z1aVUDJxofRz2QxvjkFnfqtLPifc2nWN.mcpdevus -epsw x -esm 3 -allpools 1 -estale 0 -dpool stratum+tcp://decred.eu.nicehash.com:3354 -dwal 33Z1aVUDJxofRz2QxvjkFnfqtLPifc2nWN.mcpdevus > /mcp/logs/miner.log & 

# xmr-stak
# sudo nohup /mcp/miners/xmr-stak-v2.4.7-cuda9.1/xmr-stak --currency monero7 -o stratum+tcp://xmr.pool.minergate.com:45560 -u jamie.whittingham@gmail.com -p x