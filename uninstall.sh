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
echo "Resetting Repositories"
echo " "
rm -rf /etc/apt/sources.list
mv /etc/apt/sources.list.bak /etc/apit/sources.list
apt-get update > /dev/null


## remove dependencies
echo "Removing Dependencies"
echo " "
apt-get remove -y -qq llvm-3.9 clang-3.9 software-properties-common build-essential htop nload nmap sudo zlib1g-dev gcc make git autoconf autogen automake pkg-config locate curl php php-dev php-curl dnsutils sshpass fping net-tools > /dev/null
updatedb >> /dev/null


## setup whittinghamj account
echo "Removing mcp linux user account"
echo " "
deluser mcp
rm -rf /home/mcp


## make mcp folders
echo "Removing MCP OS"
echo " "
rm -rf /mcp



## reboot
## reboot

echo "Removal Complete - Please reboot!"
