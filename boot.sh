#!/bin/bash

# set bash colors
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

# remove old *.loc files
# rm -rf /mcp/*.loc

# remove old *.log files
# rm -rf /mcp/logs/*

# stop any old miners
# php -q /mcp/console.php miner_stop > /dev/null

# create new log files
# touch /mcp/logs/console.log
# touch /mcp/logs/deamon.log
# touch /mcp/logs/miner.log

# improve disk writes to less
# mount -o remount,noatime,nodiratime,commit=120 /mnt/user
mount -o remount,noatime,nodiratime,commit=120 / 
echo noop > /sys/block/sda/queue/scheduler > /dev/null
sysctl vm.dirty_background_ratio=20 > /dev/null
sysctl vm.dirty_expire_centisecs=0 > /dev/null
sysctl vm.dirty_ratio=80 > /dev/null
sysctl vm.dirty_writeback_centisecs=0 > /dev/null
sudo sysctl -w vm.nr_hugepages=128  > /dev/null

# set GPU settings
export DISPLAY=:0
export GPU_MAX_ALLOC_PERCENT=100
export GPU_USE_SYNC_OBJECTS=1
export GPU_SINGLE_ALLOC_PERCENT=100
export GPU_MAX_HEAP_SIZE=100
export GPU_FORCE_64BIT_PTR=1

# display cool logo
figlet -c "MCP OS v1"

# display cool on screen output
echo "[ ${GREEN}OK${SET} ] Loading Core ROMs."
sleep 1

echo "[ ${GREEN}OK${SET} ] Loading Software Packages."
sleep 1

echo "[ ${GREEN}OK${SET} ] Configuring firewall."
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -X
sleep 1

echo "[ ${GREEN}OK${SET} ] Connecting to Datacenters."
sleep 1

echo "[ ${GREEN}OK${SET} ] Booting MCP OS."
sleep 1

echo "[ ${GREEN}OK${SET} ] Updating MCP OS."
## rm -rf /mcp
## mkdir /mcp
## cd /mcp
## git clone https://github.com/whittinghamj/mcpos.git . --quiet
sleep 1

echo "[ ${GREEN}OK${SET} ] Configuring MCP OS."
sleep 1

echo "[ ${GREEN}OK${SET} ] Detecting installed GPUs."
sleep 1

# check for GPU(s)
NVIDIA=`lspci | grep VGA | grep NVIDIA | wc -l`
ATI=`lspci | grep VGA | grep ATI | wc -l`

# NVIDIA GPU(s) found
if [ "$NVIDIA" -gt "0" ]; then
      echo "[ ${GREEN}OK${SET} ] NVIDIA GPUs found."
      sleep 1
      echo "[ ${GREEN}OK${SET} ] Loading monitors."

      sleep 3
      watch -n1 --color -t sudo sh /mcp/local_console.sh
      # sudo watch -n1 nvidia-smi
      exit 1
fi

# ATI GPU(s) found
if [ "$NVIDIA" -gt "0" ]; then
      echo "[ ${GREEN}OK${SET} ] ATI GPUs found."
      sleep 1
      echo "No ATI monitors are installed yet."
      exit 1
fi