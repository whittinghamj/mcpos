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

bold=$(tput bold)
normal=$(tput sgr0)

MINER_ID=$(cat /mcp/config.txt);
IPADDRESS=$(hostname -I | sed "s/ //g");
SSHPORT=$(sshd -T | head -n 1 | awk '{print $2}');

UPTIME="$(uptime)";

echo "System Health: $UPTIME"

echo "MCP Miner ID: $MINER_ID"

echo "LAN IP: $IPADDRESS | SSH PORT: $SSHPORT | WEB SSH: http://$IPADDRESS:4200" 

echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "Internet Connection: ${GREEN}Online${SET}"
else
    echo "Internet Connection: ${RED}Offline${SET}"
fi


if [ -s /mcp/site_key.txt ]
then
    HASHRATE="$(sh /mcp/stats.sh)";

    echo "Miner Hashrate: $HASHRATE"

    ## echo "Bandwidth: $BANDWIDTH"

    echo " "

    sudo nvidia-smi
else
    echo " "

    echo "${RED}!!! WARNING !!!${SET}"
    echo "Please enter your MCP Site API Key into /mcp/site_key.txt and reboot."

    exit 1
fi 