#!/bin/bash

# get worker name

# pid / lock file


# claymore-eth-v11.9
# sudo nohup /mcp/miners/claymore-eth-v11.9/ethdcrminer64 -epool stratum+tcp://daggerhashimoto.eu.nicehash.com:3353 -ewal 33Z1aVUDJxofRz2QxvjkFnfqtLPifc2nWN.mcpdevus -epsw x -esm 3 -allpools 1 -estale 0 -dpool stratum+tcp://decred.eu.nicehash.com:3354 -dwal 33Z1aVUDJxofRz2QxvjkFnfqtLPifc2nWN.mcpdevus > /mcp/logs/miner.log & 

# silentarmy
# sudo nohup /mcp/miners/silentarmy/silentarmy --use 0 -c stratum+tcp://us1-zcash.flypool.org:3333 -u t1dAGBEwP6jJVqRozRUMTp4EUzeMosAHeQz > /mcp/logs/miner.log & 

# ccminer-tpruvot-v2.3-cuda9.1
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-9.2/lib64
# sudo nohup /mcp/miners/ccminer-tpruvot-v2.3-cuda9.1/ccminer -a cryptonight -o stratum+tcp://cryptonight.eu.nicehash.com:3355 -u 33Z1aVUDJxofRz2QxvjkFnfqtLPifc2nWN -p x > /mcp/logs/miner.log & 
sudo nohup /mcp/miners/ccminer-tpruvot-v2.3-cuda9.1/ccminer -a cryptonight -o stratum+tcp://xmr.pool.minergate.com:45560 -u jamie.whittingham@gmail.com -p x > /mcp/logs/miner.log & 