#!/bin/bash

# sleep 60 seconds
sleep 60

# get worker name

# pid / lock file


# claymore-eth-v11.9 - DUAL
# sudo nohup /mcp/miners/claymore-eth-v11.9/ethdcrminer64 -epool stratum+tcp://daggerhashimoto.eu.nicehash.com:3353 -ewal 33Z1aVUDJxofRz2QxvjkFnfqtLPifc2nWN.mcpdevuk -epsw x -esm 3 -allpools 1 -estale 0 -dpool stratum+tcp://decred.eu.nicehash.com:3354 -dwal 33Z1aVUDJxofRz2QxvjkFnfqtLPifc2nWN.mcpdevuk > /mcp/logs/miner.log & 

# xmr-stak - DUAL
# sudo nohup /mcp/miners/xmr-stak-v2.4.7-cuda9.1/xmr-stak --currency monero7 -o stratum+tcp://xmr.pool.minergate.com:45560 -u jamie.whittingham@gmail.com -p x > /mcp/logs/miner.log & 

# claymore-zec - AMD
# sudo nohup /mcp/miners/claymore-zec/zecminer64 -zpool equihash.eu.nicehash.com:3357 -zwal 33Z1aVUDJxofRz2QxvjkFnfqtLPifc2nWN.mcpdevuk -zpsw x > /mcp/logs/miner.log & 

# bminer - NVIDIA
sudo nohup /mcp/miners/bminer-zec-nvidia/bminer -uri stratum://33Z1aVUDJxofRz2QxvjkFnfqtLPifc2nWN@equihash.usa.nicehash.com:3357 > /mcp/logs/miner.log & 
