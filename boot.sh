#!/bin/bash

DARKGRAY='\033[1;30m'
RED='\033[0;31m'    
LIGHTRED='\033[1;31m'
GREEN='\033[0;32m'    
YELLOW='\033[1;33m'
BLUE='\033[0;34m'    
PURPLE='\033[0;35m'    
LIGHTPURPLE='\033[1;35m'
CYAN='\033[0;36m'    
WHITE='\033[1;37m'
SET='\033[0m'


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


echo "[ ${GREEN}OK${SET} ] Loading OS Tweaks."
sleep 1

echo "[ ${GREEN}OK${SET} ] Loading Software Packages."
sleep 1

echo "[ ${GREEN}OK${SET} ] Configuring firewall."
iptables -F
iptables -t nat -F
iptables -X
sleep 1

echo "[ ${GREEN}OK${SET} ] Booting MCP OS."
sleep 1

echo "[ ${GREEN}OK${SET} ] Updating MCP OS."
sudo sh /mcp/update.sh
sleep 1

echo "[ ${GREEN}OK${SET} ] Configuring MCP OS."
sleep 1

echo "[ ${GREEN}OK${SET} ] Detecting installed GPUs."
sleep 1


NVIDIA=`lspci | grep VGA | grep NVIDIA | wc -l`
ATI=`lspci | grep VGA | grep ATI | wc -l`

if [ "$NVIDIA" -gt "0" ]; then
      echo "[ ${GREEN}OK${SET} ] NVIDIA GPUs found."
      sleep 1
      echo "[ ${GREEN}OK${SET} ] Loading monitors."

      sleep 3
      watch -n1 sudo sh /mcp/local_console.sh
      # sudo watch -n1 nvidia-smi
      exit 1
fi

if [ "$NVIDIA" -gt "0" ]; then
      echo "[ ${GREEN}OK${SET} ] ATI GPUs found."
      sleep 1
      exit 1
fi