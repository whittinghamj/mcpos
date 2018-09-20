#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

IPADDRESS=$(hostname -I | sed "s/ //g");
SSHPORT=$(sshd -T | head -n 1 | awk '{print $2}');

UPTIME="$(uptime)";

echo "${bold}System Health:${normal} $UPTIME"

echo "${bold}LAN IP${normal}: $IPADDRESS | ${bold}SSH PORT:${normal} $SSHPORT | ${bold}WEB SSH:${normal} http://$IPADDRESS:4200" 

echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "${bold}Internet Connection:${normal} Online"
else
    echo "${bold}Internet Connection:${normal} Offline"
fi


if [ -s /mcp/site_key.txt ]
then
      HASHRATE="$(sh /mcp/stats.sh)";

      echo "${bold}Miner Hashrate:${normal} $HASHRATE"

      ## echo "Bandwidth: $BANDWIDTH"

      echo " "

      sudo nvidia-smi
else

      echo "Please enter your MCP Site API Key into /mcp/site_key.txt and reboot."
      
      exit 1
fi 