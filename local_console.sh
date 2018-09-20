#!/bin/bash

IP_ADDRESS=$(hostname -I);
IPADDRESS=$IP_ADDRESS | sed -e "s/ //g";

if [ -s /mcp/site_key.txt ]
then
      HASHRATE="$(sh /mcp/stats.sh)";

      ## BANDWIDTH="$(sh /mcp/get_current_bandwidth.sh)";

      # [ -z "$HASHRATE" ] && php -q /mcp/console.php miner_restart > /mcp/logs/miner.log

      UPTIME="$(uptime)";

      echo "System Health: $UPTIME"

      echo "LAN IP: $IPADDRESS / WEB SSH: http://$IPADDRESS: 4200" 

      echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1

      if [ $? -eq 0 ]; then
              echo "Internet Connection: Online"
      else
              echo "Internet Connection: Offline"
      fi

      echo "Miner Hashrate: $HASHRATE"

      ## echo "Bandwidth: $BANDWIDTH"

      echo " "

      sudo nvidia-smi
else
      echo "Please enter your MCP Site API Key into /mcp/site_key.txt and reboot."

      echo "LAN IP: %s\n" "$IPADDRESS / WEB SSH: http://$IPADDRESS: 4200" 

      exit 1
fi 