#!/bin/bash

## MCP OS - Remove Script
echo "-----------------------"
echo "MCP OS - Remove Script"
echo "-----------------------"


## running as root check
if ! [ $(id -u) = 0 ]; then
   echo "This software will only work when being installed by the 'rppt' user."
   exit 1
fi


## set base folder
cd /root


## update apt-get repos
# echo "Resetting Repositories"
# echo " "
# rm -rf /etc/apt/sources.list > /dev/null
# mv /etc/apt/sources.list.bak /etc/apit/sources.list > /dev/null
# apt-get update > /dev/null


## remove dependencies
echo "Removing Dependencies"
echo " "
apt-get remove -y -qq llvm-3.9 clang-3.9 software-properties-common php php-dev php-curl sshpass fping > /dev/null


## setup whittinghamj account
echo "Removing mcp linux user account"
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
