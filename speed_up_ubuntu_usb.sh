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

# improve disk writes to less
mount -o remount,noatime,nodiratime,commit=120 / 
echo noop > /sys/block/sda/queue/scheduler > /dev/null
sysctl vm.dirty_background_ratio=20 > /dev/null
sysctl vm.dirty_expire_centisecs=0 > /dev/null
sysctl vm.dirty_ratio=80 > /dev/null
sysctl vm.dirty_writeback_centisecs=0 > /dev/null

# lower swap partition use so that 90% of RAM is used instead of hard drive
sysctl vm.swappiness=10 > /dev/null

