#!/bin/bash

## set vars
UUID="$(dmidecode --string baseboard-serial-number | sed 's/.*ID://;s/ //g' | tr '[:upper:]' '[:lower:]')"
MAC="$(ifconfig | grep eth0 | awk '{print $NF}' | sed 's/://g' | tr '[:upper:]' '[:lower:]')"
AUTH="$(echo $UUID | sha256sum | awk '{print $1}')"


## MCP OS - Install Script
echo "-----------------------"
echo "MCP OS - Install Script"
echo "-----------------------"


## running as root check
if ! [ $(id -u) = 0 ]; then
   echo "This software will only work when being installed by the 'root' user."
   exit 1
fi


## set base folder
cd /root


## update apt-get repos
# echo "Updating Repositories"
# echo " "
# cp /etc/apt/sources.list /etc/apt/sources.list.bak
# sed -i 's/main/main contrib non-free/g'  /etc/apt/sources.list
# apt-get update > /dev/null


## upgrade all packages
# echo "Upgrading Core OS"
# echo " "
# apt-get -y -qq upgrade > /dev/null


## install dependencies
echo "Installing Dependencies"
echo " "
## apt-get install -y -qq llvm-3.9 clang-3.9 software-properties-common build-essential htop nload nmap sudo zlib1g-dev gcc make git autoconf autogen automake pkg-config locate curl php php-dev php-curl dnsutils sshpass fping net-tools > /dev/null
apt-get install -y -qq htop nload nmap sudo zlib1g-dev gcc make git autoconf autogen automake pkg-config locate curl php php-dev php-curl dnsutils sshpass fping net-tools lshw > /dev/null
updatedb >> /dev/null


## echo "Installing NVIDIA Drivers"
## echo " "
## apt-get install -y -qq linux-headers-$(uname -r|sed 's/[^-]*-[^-]*-//') nvidia-driver > /dev/null
## apt-get install -t -qq stretch-backports nvidia-driver >> /dev/null


## download custom scripts
echo "Downloading Custom Scripts"
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


## remove old software
mkdir /old_software
mv /root/utils /old_software
mv /root/start.sh /old_software
mv /root/xminer.sh /old_software

## set ssh port
echo "Updating SSHd details"
echo " "
## sed -i 's/#Port 22/Port 33077/' /etc/ssh/sshd_config
sed -i 's/#AddressFamily any/AddressFamily inet/' /etc/ssh/sshd_config
/etc/init.d/ssh restart > /dev/null


## set controller hostname
echo "Setting Hostname"
echo " "
echo 'mcpos' > /etc/hostname
sed -i 's/simpleminer/mcpos/' /etc/hosts


## make mcp folders
echo "Installing MCP OS"
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

usermod --lock --shell /bin/nologin miner
deluser miner
rm -rf /home/miner

mkdir /mcp
cd /mcp


## get the mcp files
git clone https://github.com/whittinghamj/mcpos.git . --quiet


## set the cronfile
crontab /mcp/crontab.txt


## build the config files
echo "$UUID" > "/mcp/config.txt"
echo "$UUID" > "/mcp/uuid.txt"
echo "$MAC" > "/mcp/mac.txt"
echo "$AUTH" > "/mcp/auth.txt"
echo "System ID: $UUID" > "/etc/motd"
echo "System Auth Code: $AUTH" >> "/etc/motd"


# echo "\n\n"
# echo "Please enter your MCP Site API Key:"

# read site_api_key

# echo '<?php

# $config['"'"api_key"'"'] = '"'$site_api_key';" > /mcp/config.txt
# echo " "

## reboot
## reboot


echo " "
echo "Installation Complete"
echo " "
echo "System ID: ${UUID}"
echo "System Auth Code: ${AUTH}"
echo "Please enter the System Auth Code into MCP to claim this miner."