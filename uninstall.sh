#!/bin/bash

## MCP OS - Remove Script
echo "-----------------------"
echo "MCP OS - Remove Script"
echo "-----------------------"


## running as root check
if ! [ $(id -u) = 0 ]; then
   echo "This software will only work when being installed by the 'root' user."
   exit 1
fi


## set base folder
cd /root


## update apt-get repos
# echo "Resetting Repositories"
# echo " "
# rm -rf /etc/apt/sources.list > /dev/null
# mv /etc/apt/sources.list.bak /etc/apit/sources.list > /dev/null
# sonos
apt-get update > /dev/null


## remove dependencies
echo "Removing Dependencies"
echo " "
apt-get remove -y -qq php php-dev php-curl sshpass fping > /dev/null


## revert hostname
echo "Setting Hostname"
echo " "
echo 'ubuntu' > /etc/hostname
sed -i 's/mcpos/ubuntu/' /etc/hosts


## setup whittinghamj account
echo "Removing mcp Linux User Account"
echo " "
deluser mcp > /dev/null
rm -rf /home/mcp > /dev/null


## make mcp folders
echo "Removing MCP OS"
echo " "
rm -rf /mcp > /dev/null



## reboot
## reboot

echo "Removal Complete - Please reboot!"
