#!/usr/bin/env bash


## MCP OS - Install Script
echo "MCP OS - Installation Script"

## running as root check
if ! [ $(id -u) = 0 ]; then
   echo "This software will only work when being installed by the 'root' user."
   exit 1
fi

set -e


# rm -rf /etc/apt/sources.list > /dev/null
# wget -O /etc/apt/sources.list http://miningcontrolpanel.com/mcpos/sources.list > /dev/null
sudo sed -i 's/deb cdrom/#deb cdrom/g' /etc/apt/sources.list
sudo apt-get install -y -qq net-tools dnsutils git > /dev/null


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
sudo apt-get -y -qq upgrade > /dev/null


## install dependencies
echo "Installing Dependencies"
echo " "
## apt-get install -y -qq llvm-3.9 clang-3.9 software-properties-common build-essential htop nload nmap sudo zlib1g-dev gcc make git autoconf autogen automake pkg-config locate curl php php-dev php-curl dnsutils sshpass fping net-tools > /dev/null
sudo apt-get install -y -qq aha bc screen cmake software-properties-common htop nload nmap sudo zlib1g-dev gcc make git autoconf autogen automake pkg-config locate curl php php-dev php-curl dnsutils sshpass fping net-tools lshw shellinabox > /dev/null
sudo updatedb > /dev/null


# setup SSH identity
[ -e ~/.ssh/id_rsa ] || ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''


# install tools we'll use later
sudo apt-get install -y -qq jq curl openssh-server openssh-client ubuntu-drivers-common > /dev/null


# remove other useless things
sudo apt-get -y autoremove > /dev/null


# upgrade what we can
sudo apt-get -y upgrade > /dev/null


## configure shellinabox
sudo sed -i 's/--no-beep/--no-beep --disable-ssl/g' /etc/default/shellinabox
sudo invoke-rc.d shellinabox restart

## echo "Installing NVIDIA Drivers"
## echo " "
## apt-get install -y -qq linux-headers-$(uname -r|sed 's/[^-]*-[^-]*-//') nvidia-driver > /dev/null
## apt-get install -t -qq stretch-backports nvidia-driver >> /dev/null


## download custom scripts
echo "Downloading Custom Scripts"
echo " "
sudo wget -q http://miningcontrolpanel.com/mcpos/scripts/speedtest.sh
sudo rm -rf /root/.bashrc
sudo wget -q http://miningcontrolpanel.com/mcpos/scripts/.bashrc
sudo wget -q http://miningcontrolpanel.com/mcpos/scripts/myip.sh
sudo rm -rf /etc/skel/.bashrc
sudo cp /root/.bashrc /etc/skel
sudo chmod 700 /etc/skel/.bashrc
sudo cp /root/myip.sh /etc/skel
sudo chmod 700 /etc/skel/myip.sh
# sudo source /root/.bashrc


## remove old software
## mkdir /old_software
## mv /root/utils /old_software > /dev/null
## mv /root/start.sh /old_software > /dev/null
## mv /root/xminer.sh /old_software > /dev/null


## set ssh port
echo "Updating SSHd details"
echo " "
## sed -i 's/#Port 22/Port 33077/' /etc/ssh/sshd_config
sudo sed -i 's/#AddressFamily any/AddressFamily inet/' /etc/ssh/sshd_config
sudo /etc/init.d/ssh restart > /dev/null


## set controller hostname
echo "Setting Hostname"
echo " "
echo 'mcpos' > /etc/hostname
sudo sed -i 's/simpleminer/mcpos/' /etc/hosts
sudo sed -i 's/localhost/mcpos/' /etc/hosts
sudo sed -i 's/miner/mcpos/' /etc/hosts
sudo sed -i 's/rig/mcpos/' /etc/hosts
sudo sed -i 's/gpu/mcpos/' /etc/hosts
sudo sed -i 's/mine/mcpos/' /etc/hosts
sudo sed -i 's/gpuminer/mcpos/' /etc/hosts
sudo sed -i 's/debian/mcpos/' /etc/hosts
sudo sed -i 's/workstation/mcpos/' /etc/hosts
sudo sed -i 's/server/mcpos/' /etc/hosts


## make mcp folders
echo "Installing MCP OS"
echo " "
sudo useradd -m -p eioruvb9eu839ub3rv mcp
echo "mcp:"'mcp' | chpasswd > /dev/null
sudo usermod --shell /bin/bash mcp
sudo mkdir /home/mcp/.ssh
sudo echo "Host *" > /home/mcp/.ssh/config
sudo echo " StrictHostKeyChecking no" >> /home/mcp/.ssh/config
sudo chmod 400 /home/mcp/.ssh/config
sudo usermod -aG sudo mcp
sudo echo "mcp    ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers


## old - modding SMOS
# usermod --lock --shell /bin/nologin miner > /dev/null
# deluser miner > /dev/null
# rm -rf /home/miner > /dev/null


sudo mkdir /mcp
cd /mcp


## get the mcp files
sudo git clone https://github.com/whittinghamj/mcpos.git . --quiet


## set the cronfile
sudo crontab /mcp/crontab.txt


## build the config files
# echo "$UUID" > "/mcp/config.txt"
# echo "$UUID" > "/mcp/uuid.txt"
# echo "$MAC" > "/mcp/mac.txt"
# echo "$AUTH" > "/mcp/auth.txt"

# echo "" > /etc/motd
# echo "=======================================================================================" >> /etc/motd
# echo "System ID: $UUID" >> "/etc/motd"
# echo "System Auth Code: $AUTH" >> "/etc/motd"
# echo "=======================================================================================" >> /etc/motd


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
sudo chmod -x /etc/update-motd.d/91-release-upgrade


echo "Configuring NVIDIA GPUs"
echo " "
#####
# Global Settings
#####
NVIDIA_CUDA_REPO="http://developer.download.nvidia.com/compute/cuda/repos"

#####
# Read Input
#####

while [[ $# -gt 0 ]]; do

	key="$1"

	case $key in
		--nvidia-ubuntu-version|-v)
		NVIDIA_UBUNTU_VERSION="$2"
		shift
		;;
	esac

	shift
done

#####
# Compute Input
#####

eval `cat /etc/lsb-release`


if [ -z "${NVIDIA_UBUNTU_VERSION}" ]; then
	echo "Detecting Ubuntu version to use for NVidia drivers..."

	NVIDIA_UBUNTU_VERSION=$(echo $DISTRIB_RELEASE | tr -d '.')
	echo -e "\tUbuntu version = [${DISTRIB_RELEASE}]; using [${NVIDIA_UBUNTU_VERSION}]."
fi

#####
# Validate Input
#####


if [ -z "${NVIDIA_UBUNTU_VERSION}" ]; then
	echo "ERROR: Please specify the --nvidia-ubuntu-version to use to look for NVidia drivers."
	exit 1
else
	NVIDIA_REPO_BASE="${NVIDIA_CUDA_REPO}/ubuntu${NVIDIA_UBUNTU_VERSION}/x86_64"
	echo -e "\tFinding latest NVidia CUDA drivers at [${NVIDIA_REPO_BASE}]..."
	NVIDIA_REPO_NAME=$(wget -qO- ${NVIDIA_REPO_BASE} | grep cuda-repo-ubuntu${NVIDIA_UBUNTU_VERSION} | awk -F [\'] '{print $4}' | sort -rh | head -n 1)

	if [ -z "${NVIDIA_REPO_NAME}" ]; then
		echo "ERROR: Couldn't find CUDA drivers for Ubuntu version [${NVIDIA_UBUNTU_VERSION}]; please check [${NVIDIA_CUDA_REPO}] for an 'ubuntu${DISTRIB_RELEASE%.*}xx' directory, then run again with the '--nvidia-ubuntu-version ${DISTRIB_RELEASE%.*}xx' flag."
		exit 1
	fi
	NVIDIA_REPO_URL="${NVIDIA_REPO_BASE}/${NVIDIA_REPO_NAME}"
	echo -e "\t ... found [${NVIDIA_REPO_NAME}]"

fi

set -x
set -e

#####
# NVidia Drivers
#####

# add nvidia driver repo
sudo add-apt-repository -y ppa:graphics-drivers/ppa

# add cuda driver repo
wget --quiet --output-document="/tmp/${NVIDIA_REPO_NAME}" "${NVIDIA_REPO_URL}"
sudo dpkg -i /tmp/${NVIDIA_REPO_NAME}

# add CUDA driver repo gpg key
NVIDIA_CUDA_REPO_KEYFILE=$(wget -qO- http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1704/x86_64/ | awk -F[\'] '/.pub/{print $4}')
sudo apt-key adv --fetch-keys "${NVIDIA_REPO_BASE}/${NVIDIA_CUDA_REPO_KEYFILE}"

# RANDOM INTERNET TROUBLESHOOTING:
# kill plymouth
sudo pkill plymouth || true # (it might not be running...)

# update apt; we're ready
sudo apt-get update

# TODO: eventually figure out how to compute LATEST_NVIDIA_CUDA_DRIVERS w/out gawk
sudo apt-get install -y gawk

# install nvidia drivers
LATEST_NVIDIA_DRIVER=$(sudo ubuntu-drivers devices | awk '/driver.*?nvidia/{print $3}' | sort -r | head -n 1)
LATEST_CUDA_NVIDIA_DRIVER=$(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances --no-pre-depends cuda | gawk 'match($0, /nvidia-([0-9]+)/, ary) {print ary[1]}' | sort -r | head -n 1)

if [ -e ~/.nvidia-version ]; then
	# nvidia drivers have been installed BY THIS SCRIPT previously.
	CURRENT_NVIDIA_DRIVER=$(cat ~/.nvidia-version)

	if [ "${CURRENT_NVIDIA_DRIVER}" != "${LATEST_CUDA_NVIDIA_DRIVER}" ]; then
		# cuda wants a different nvidia driver version than what is installed.
		# need to purge all nvidia drivers and re-install
		rm -f ~/.nvidia-version
		sudo apt-get purge -y nvidia-*
	fi
else
	# nvidia drivers have not been installed by this script before
	# purge all existing nvidia drivers.
	sudo apt-get purge -y nvidia-*
fi

if [ ! -e ~/.nvidia-version ]; then
	# Drivers are NOT installed.
	# install them.

	# sometimes nvidia drivers run ahead of what CUDA supports. Don't install them.
	# sudo apt-get install -y ${NVIDIA_DRIVER}

	# install (latest) CUDA drivers
	sudo apt-get install -y cuda nvidia-settings
fi

# Remove non-nvidia drivers
sudo apt-get purge -y xserver-xorg-video-nouveau

# configure NVidia drivers
sudo nvidia-xconfig --cool-bits=4 # enable direct fan control
sudo nvidia-xconfig --enable-all-gpus #(you can figure this one out)

# configure support for headless operation (there probably won't be a monitor on EVERY GPU)
sudo nvidia-xconfig --allow-empty-initial-configuration

# set "nomodeset" so GRUB can still boot to a GUI if someone does connect a monitor
# https://askubuntu.com/questions/38780/how-do-i-set-nomodeset-after-ive-already-installed-ubuntu
sudo sed -i '/GRUB_CMDLINE_LINUX_DEFAULT=/ c\GRUB_CMDLINE_LINUX_DEFAULT="nosplash nomodeset"' /etc/default/grub

# only NEEDED if using full-disk encryption; appears harmless if not
sudo update-initramfs -u

#####
# Housekeeping
#####

# remove useless things that the internet says cause trouble with NVidia
sudo apt-get remove -y fwupd

JUST_INSTALLED_NVIDIA_VERSION=$(dpkg -l | awk -F '[ -]' '/nvidia-[0-9]+/{print $4}' | sort -r | head -n 1)

#if [ -e ~/.nvidia-version ] && [ "${JUST_INSTALLED_NVIDIA_VERSION}" == "$(cat ~/.nvidia-version)" ]; then
	# The installer has run previously, because the nvidia version is recorded.
	# The current nvidia drivers are also the latest.
	# there is no need to reboot.
	# 62 wide, 60 usable, 58 used
#	cat <<- EOF
#	+===========================================================+
#	| NVidia drivers installed                                  |
#	+===========================================================+
#	EOF
#else
	# Either there is no record of nvidia driver installation (meaning probably the first time)
	# or they are outdated (meaning we probably installed new ones)
	# need to reboot.

#	echo "${JUST_INSTALLED_NVIDIA_VERSION}" > ~/.nvidia-version

	# 62 wide, 60 usable, 58 used
#	cat <<- EOF
#	+===========================================================+
#	| NVidia drivers installed                                  |
#	|                                                           |
#	| It looks like this version hasn't been installed before.  |
#	| Your computer will now reboot.                            |
#	|                                                           |
#	| Please run these scripts again when you log back in.      |
#	| You will not have to reboot a second time.                |
#	+===========================================================+
#	EOF

	# sudo reboot
#fi

## update grub for console mode
sudo sed -i 's/GRUB_DEFAULT=0/GRUB_DEFAULT=5/g' /etc/default/grub
sudo sed -i 's/GRUB_HIDDEN_TIMEOUT=0/GRUB_HIDDEN_TIMEOUT=10/g' /etc/default/grub
sudo sed -i 's/GRUB_HIDDEN_TIMEOUT_QUIET=true/GRUB_HIDDEN_TIMEOUT_QUIET=false/g' /etc/default/grub
sudo sed -i 's/#GRUB_TERMINAL=console/GRUB_TERMINAL=console/g' /etc/default/grub
sudo sed -i 's/#GRUB_GFXMODE=640x480/GRUB_GFXMODE=1024x768/g' /etc/default/grub
sudo update-grub


## enable auto login
mkdir /etc/systemd/system/getty@tty1.service.d
touch /etc/systemd/system/getty@tty1.service.d/override.conf
echo '[Service]' > /etc/systemd/system/getty@tty1.service.d/override.conf
echo 'ExecStart=' >> /etc/systemd/system/getty@tty1.service.d/override.conf
echo 'ExecStart=-/sbin/agetty --noissue --autologin mcp %I $TERM' >> /etc/systemd/system/getty@tty1.service.d/override.conf
echo 'Type=idle' >> /etc/systemd/system/getty@tty1.service.d/override.conf


## auto tail log file on boot
echo 'clear' >> /home/mcp/.profile
echo 'sudo sh /mcp/boot.sh' >> /home/mcp/.profile


## cleanup
chmod 777 /mcp


echo "Installation Complete"
echo " "
# echo "System ID: ${UUID}"
# echo "System Auth Code: ${AUTH}"
# echo " "
echo "You need to reboot this machine to start mining."
echo "Once the machine has rebooted you will be able to"
echo "start mining by configuring it on the MCP portal."
