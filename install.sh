#!/bin/bash

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
cp /etc/apt/sources.list /etc/apt/sources.list.bak
sed -i 's/main/main contrib non-free/g'  /etc/apt/sources.list
apt-get update > /dev/null


## upgrade all packages
echo "Upgrading Core OS"
echo " "
apt-get -y -qq upgrade > /dev/null


## install dependencies
echo "Installing Dependencies"
echo " "
apt-get install -y -qq llvm-3.9 clang-3.9 software-properties-common build-essential htop nload nmap sudo zlib1g-dev gcc make git autoconf autogen automake pkg-config locate curl php php-dev php-curl dnsutils sshpass fping net-tools > /dev/null
updatedb >> /dev/null


## download custom scripts
echo "Downloading custom scripts"
echo " "
wget -q http://deltacolo.com/scripts/speedtest.sh
rm -rf /root/.bashrc
wget -q http://deltacolo.com/scripts/.bashrc
wget -q http://deltacolo.com/scripts/myip.sh
rm -rf /etc/skel/.bashrc
cp /root/.bashrc /etc/skel
chmod 777 /etc/skel/.bashrc
cp /root/myip.sh /etc/skel
chmod 777 /etc/skel/myip.sh


## setup whittinghamj account
echo "Adding mcp linux user account"
echo " "
useradd -m -p eioruvb9eu839ub3rv mcp
echo "mcp:"'mcp' | chpasswd > /dev/null
usermod --shell /bin/bash mcp
mkdir /home/mcp/.ssh
echo "Host *" > /home/mcp/.ssh/config
echo " StrictHostKeyChecking no" >> /home/mcp/.ssh/config
chmod 400 /home/mcp/.ssh/config
usermod -aG sudo mcp
echo "mcp    ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers


## update root account
mkdir /root/.ssh
echo "Host *" > /root/.ssh/config
echo " StrictHostKeyChecking no" >> /root/.ssh/config


## make mcp folders
echo "Installing MCP OS"
echo " "
mkdir /mcp
cd /mcp


## get the mcp files
git clone https://github.com/whittinghamj/mcpos.git . --quiet


## build the config file with site api key
touch /mcp/config.txt
echo "\n\n"
echo "Please enter your MCP Site API Key:"

read site_api_key

echo '<?php

$config['"'"api_key"'"'] = '"'$site_api_key';" > /mcp/config.txt
echo " "

crontab crontab.txt

## reboot
## reboot

echo "Installation Complete - Please reboot!"
