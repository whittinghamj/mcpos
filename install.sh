#!/bin/bash


## MCP OS - Install Script
echo "MCP OS - Installation Script"

## running as root check
if ! [ $(id -u) = 0 ]; then
   echo "This software will only work when being installed by the 'root' user."
   exit 1
fi


# rm -rf /etc/apt/sources.list > /dev/null
# wget -O /etc/apt/sources.list http://miningcontrolpanel.com/mcpos/sources.list > /dev/null
sed -i 's/deb cdrom/#deb cdrom/g'  /etc/apt/sources.list
apt-get install -y -qq net-tools dnsutils git > /dev/null


## set vars
UUID="$(dmidecode --string system-uuid | tr '[:upper:]' '[:lower:]')"
MAC="$(ifconfig | grep eth0 | awk '{print $NF}' | sed 's/://g' | tr '[:upper:]' '[:lower:]')"
AUTH="$(echo $UUID | sha256sum | awk '{print $1}')"


## set base folder
cd /root


## update apt-get repos
# echo "Updating Repositories"
# echo " "
# cp /etc/apt/sources.list /etc/apt/sources.list.bak
# sed -i 's/main/main contrib non-free/g'  /etc/apt/sources.list
# apt-get update > /dev/null


## upgrade all packages
echo "Upgrading Core OS"
echo " "
apt-get -y -qq upgrade > /dev/null


## install dependencies
echo "Installing Dependencies"
echo " "
## apt-get install -y -qq llvm-3.9 clang-3.9 software-properties-common build-essential htop nload nmap sudo zlib1g-dev gcc make git autoconf autogen automake pkg-config locate curl php php-dev php-curl dnsutils sshpass fping net-tools > /dev/null
apt-get install -y -qq htop nload nmap sudo zlib1g-dev gcc make git autoconf autogen automake pkg-config locate curl php php-dev php-curl dnsutils sshpass fping net-tools lshw shellinabox > /dev/null
updatedb >> /dev/null


## configure shellinabox
sed -i 's/--no-beep/--no-beep --disable-ssl/g' /etc/default/shellinabox
invoke-rc.d shellinabox restart

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
## mkdir /old_software
## mv /root/utils /old_software > /dev/null
## mv /root/start.sh /old_software > /dev/null
## mv /root/xminer.sh /old_software > /dev/null


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
sed -i 's/localhost/mcpos/' /etc/hosts
sed -i 's/miner/mcpos/' /etc/hosts
sed -i 's/rig/mcpos/' /etc/hosts
sed -i 's/gpu/mcpos/' /etc/hosts
sed -i 's/mine/mcpos/' /etc/hosts
sed -i 's/gpuminer/mcpos/' /etc/hosts
sed -i 's/debian/mcpos/' /etc/hosts
sed -i 's/workstation/mcpos/' /etc/hosts
sed -i 's/server/mcpos/' /etc/hosts


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


## old - modding SMOS
# usermod --lock --shell /bin/nologin miner > /dev/null
# deluser miner > /dev/null
# rm -rf /home/miner > /dev/null


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

echo "" > /etc/motd
echo "=======================================================================================" >> /etc/motd
echo "System ID: $UUID" >> "/etc/motd"
echo "System Auth Code: $AUTH" >> "/etc/motd"
echo "=======================================================================================" >> /etc/motd


# echo "\n\n"
# echo "Please enter your MCP Site API Key:"

# read site_api_key

# echo '<?php

# $config['"'"api_key"'"'] = '"'$site_api_key';" > /mcp/config.txt
# echo " "

## reboot
## reboot

## cleanup
## disable ubuntu distro upgrade MOTD notice
chmod -x /etc/update-motd.d/91-release-upgrade


echo " "
echo "Installation Complete"
echo " "
echo "System ID: ${UUID}"
echo "System Auth Code: ${AUTH}"
echo " "
echo "Please enter the System ID and Auth Code into MCP to claim this miner."