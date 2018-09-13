#!/bin/bash

## check for active internet connection
echo "###################################################"
echo "Checking connection to Internet..."
i=0
while [ "$i" -le 6 ]; do
  # timeout 10 works about 20 seconds :)
  CZY=`host -W 10 -t SOA miningcontrolpanel.com | grep -ci "miningcontrolpanel.com"`
  if [ "$CZY" -gt 0 ]; then
    echo "Internet OK."
    break
  fi
  i=$((i+1))
  echo "Probing"
done

echo "###################################################"

echo "Registering miner at miningcontrolpanel.com... "

echo "###################################################"

echo "Miner is starting... "

# get worker name

# pid / lock file


# claymore-eth-v11.9 - DUAL
# sudo nohup /mcp/miners/claymore-eth-v11.9/ethdcrminer64 -epool stratum+tcp://daggerhashimoto.eu.nicehash.com:3353 -ewal 33Z1aVUDJxofRz2QxvjkFnfqtLPifc2nWN.mcpdevuk -epsw x -esm 3 -allpools 1 -estale 0 -dpool stratum+tcp://decred.eu.nicehash.com:3354 -dwal 33Z1aVUDJxofRz2QxvjkFnfqtLPifc2nWN.mcpdevuk > /mcp/logs/miner.log & 

# xmr-stak - DUAL
# sudo nohup /mcp/miners/xmr-stak-v2.4.7-cuda9.1/xmr-stak --currency monero7 -o stratum+tcp://xmr.pool.minergate.com:45560 -u jamie.whittingham@gmail.com -p x > /mcp/logs/miner.log & 

# claymore-zec - AMD
# sudo nohup /mcp/miners/claymore-zec/zecminer64 -zpool equihash.eu.nicehash.com:3357 -zwal 33Z1aVUDJxofRz2QxvjkFnfqtLPifc2nWN.mcpdevuk -zpsw x > /mcp/logs/miner.log & 

# bminer - NVIDIA
sudo nohup /mcp/miners/bminer-zec-nvidia/bminer -uri stratum://33Z1aVUDJxofRz2QxvjkFnfqtLPifc2nWN@equihash.usa.nicehash.com:3357 | tee /mcp/logs/miner.log & 
