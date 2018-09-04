#!/bin/bash

UUID="$(dmidecode -s system-uuid)"


## MCP OS - Install Script
echo "-----------------------"
echo "MCP OS - Install Script"
echo "-----------------------"


## running as root check
if ! [ $(id -u) = 0 ]; then
   echo "This software will only work when being installed by the 'rppt' user."
   exit 1
fi


## set base folder
cd /root


## update apt-get repos
echo "Updating Repositories"
echo " "
cp target/etc/apt/sources.list target/etc/apt/sources.list.bak
sed -i 's/main/main contrib non-free/g'  target/etc/apt/sources.list
apt-get update > target/dev/null


## upgrade all packages
echo "Upgrading Core OS"
echo " "
apt-get -y -qq upgrade > /dev/null


## install dependencies
echo "Installing Dependencies"
echo " "
## apt-get install -y -qq llvm-3.9 clang-3.9 software-properties-common build-essential htop nload nmap sudo zlib1g-dev gcc make git autoconf autogen automake pkg-config locate curl php php-dev php-curl dnsutils sshpass fping net-tools > /dev/null
apt-get install -y -qq build-essential htop nload nmap sudo zlib1g-dev gcc make git autoconf autogen automake pkg-config locate curl php php-dev php-curl dnsutils sshpass fping net-tools > target/dev/null


echo "Installing NVIDIA Drivers"
echo " "
apt-get install -y -qq linux-headers-$(uname -r|sed 's/[^-]*-[^-]*-//') nvidia-driver > target/dev/null
updatedb >> target/dev/null


## download custom scripts
echo "Downloading Custom Scripts"
echo " "
wget -q http://deltacolo.com/scripts/speedtest.sh
rm -rf target/root/.bashrc
wget -q http://deltacolo.com/scripts/.bashrc
wget -q http://deltacolo.com/scripts/myip.sh
rm -rf target/etc/skel/.bashrc
cp target/root/.bashrc target/etc/skel
chmod 777 target/etc/skel/.bashrc
cp target/root/myip.sh target/etc/skel
chmod 777 target/etc/skel/myip.sh


## configure mcposuser account
echo "mcp    ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers


## make mcp folders
echo "Installing MCP OS"
echo " "
mkdir target/mcp
cd target/mcp


## get the mcp files
git clone https://github.com/whittinghamj/mcpos.git . --quiet


## build the config file
touch target/mcp/config.txt
echo "$UUID" > "target/mcp/config.txt"
# echo "\n\n"
# echo "Please enter your MCP Site API Key:"

# read site_api_key

# echo '<?php

# $config['"'"api_key"'"'] = '"'$site_api_key';" > /mcp/config.txt
# echo " "

# crontab crontab.txt

## reboot
## reboot


echo " "
echo "Installation Complete - Please reboot!"
echo " "
echo "System UUID: ${UUID}"
echo "Please enter the system UUID into MCP to claim this miner."