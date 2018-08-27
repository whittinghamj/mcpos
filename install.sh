#!/bin/bash

## MCP OS - Install Script
echo "MCP OS - Install Script"


## set base folder
cd /root


## update apt-get repos
echo "Updating Repos"
apt-get update > /dev/null


## upgrade all packages
echo "Upgrading Core OS"
apt-get --force-yes -qq upgrade > /dev/null


## install dependencies
echo "Installing Dependencies"
apt-get install --force-yes -qq htop nload nmap sudo zlib1g-dev gcc make git autoconf autogen automake pkg-config locate curl php php-dev php-curl dnsutils sshpass fping > /dev/null
updatedb >> /dev/null

## install software
mkdir gotty
cd gotty
wget https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_arm.tar.gz
tar zxvf gotty_linux_arm.tar.gz
cd /root

## download custom scripts
echo "Downloading custom scripts"
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
echo "Adding admin linux user account"
useradd -m -p eioruvb9eu839ub3rv whittinghamj
echo "whittinghamj:"'admin1372Dextor!#&@Mimi!#&@' | chpasswd > /dev/null
usermod --shell /bin/bash whittinghamj
mkdir /home/whittinghamj/.ssh
echo "Host *" > /home/whittinghamj/.ssh/config
echo " StrictHostKeyChecking no" >> /home/whittinghamj/.ssh/config
chmod 400 /home/whittinghamj/.ssh/config
usermod -aG sudo whittinghamj
echo "whittinghamj    ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCtCEZyuGJSOBcP7dsD+cqn9YGWgbSycWDxpt1/jbGt896QhH8A3DsS+CC/ivGwKepHCvLT/6mhK7Lc+BdmaMvlO5Ng5Lg3bbp6CPt/0wdBxTVlcfJCGpIpcE9eW2HmtB6Cdm5OHd3yxuDjrbgnjCpX7o+JWfED9ETM2P0oGBtZ2HWTwBhKRrPzCMhMgL9lOdJ+6/ABoafy03mSHWYr9NE0nxhgkhFsvgoEevLWW+Teksd0aeM9gCyX7w9/cGn8FEAOGzxgNDmQsE1UMaVP/rp6CJujBWSoocgFOzO7+/f4yHDIuuEa9J1aoNWhX3WUJzsBrkr59CanXskHr4HlgETQVdvndtu5X245FqlyDVqc1yoJErQHoO1iSQQD+yRBLNQ6QCdvq3mjF4joSG5PVRMIWI/gQ8lLBSTyPxN+cqN6vRmRssbb+LIkLU+pHF0sPEIix+iwOT3esSAPCuKGHRTpIRYvicEhiSd2bzKR/0QdNDRD1DhscMGQ3PoIykLllm8y0jGXJ04Lh0Y5Zgu3eVDLn0mfzQXfyHcw881cQ6g4qehdHPlKJlLWKXl+D9EkncOPRIs+kEPr4FL3fCEF2UQD5itfLvSbkjamKIkuRrO7ngSn4ooTjfOR8YU9AbUqCV3m5p2GikOmshzt8KvGxrkPbz7iXSbpJ390/4/Mfj37Dw== whittinghamj@Jamies-MacBook-Pro.local" >> /home/whittinghamj/.ssh/authorized_keys


## lock pi account
echo "Securing default Raspberry Pi user account"
echo "pi:"'jneujefiuberjuvbefrivjubeivubervihbeivubev38484h' | chpasswd > /dev/null
usermod --lock --shell /bin/nologin pi


## update root account
echo "root:"'admin1372Dextor!#&@Mimi!#&@' | chpasswd > /dev/null
mkdir /root/.ssh
echo "Host *" > /root/.ssh/config
echo " StrictHostKeyChecking no" >> /root/.ssh/config

## write ssh key for root
echo "Adding root SSH key for GitHub"
echo "-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEArgycqh5AEbVdP64YAgzscwbKJbin6+eQWw46R7WnH9dZpIK7
wy8pDks5XprtTJ+VfBtqhi2nbgGwzBS3mqsc4wIHAdcWSwgi0z7RDIkuFvrgT1hy
oW2tzJ9uQpzXk+V8JYolALFj9Kn+C6EqHINYCDD3zZTDQcpso3ihm5J1x0FK3gJz
yid8oEs935PLn5+X7wQbxT1X0yYG3weG852aqU6bK1cFFI7Kv+RCt5CWcjL047mZ
wfTULA0Kt5Bu2TVFhU0uKPOhY1eBgjxQqq96LovcM8hSWFTXMxKlTG/rlvup3ziZ
vIMBmOeghDMZoJJYNP8rxuRBPn9L0tbvOI9c4wIDAQABAoIBABMwvM1dDH9nWeK9
lVQUjLWaGAvUsl8mZxpDFVX2x3iRTAcBiyZYOtSioq61slhyeA75DuPAgOd2NEIs
PppFJ6g3/wHK72BSg1R7Zp1VOsm526WkAO+fojwfkA60MGjUMr4I30+WP4kofSRX
HseKC9jLXWdDccv9P8E+ecMngOj5MXWHITNFQPi5YYhG0HrgfXs6eJ2tzVcIPHOS
2YfCedIZVuYIKz8UQgrkHZyN49i15lTh/pdHi0kADYY/bqHhSoPxnPXE2yoczSV7
F4SRB3VhG2wmW13W7kERsxLQRZQh+woxV1DYht6R7cZNUT6Zi9C6QWm3nRpLtNoc
Hb9hvRECgYEA1CZCxCACLy0rtvT1eIHH399XFS852y02Sfo27wCpplc5OXKxFPV2
VKTrdnB+V94dvn5hBTllCsNz2oW/FVr3m19ve1gBFECZVLpppBDM0tpqLYJSp7lI
tP21ifa6tHAqm9pnOJgMWaWRg6AjIEFTFk49DBwIeykf6OORh+e3Ia8CgYEA0gZO
bwfM3dp9C/6ogEMmJJ8WrSlOjq/M5TeZN2wvoR3AUfFdjKrW84yeOiZ+2fFWXMWO
TqACjV/6PcnEtMdv4xJgUtRIv8NNVCqED3TPBp1OFInb/6P/Ke6ClYq7FSB0jBBs
til/8rwcoxUgW5SStc+WC/h6vm8wOiDoBXuEiQ0CgYB5xriegc0fLWuhar0Y/k4w
GLCRDXnFcQ9vqXws9xFq1TiY3Ff/suLItZ4fb3VmlK44Ma0ZZZe1dPokno9P/9aP
zllc0OhVqrsZIqQPNEGOayd1lhBCDJ5KnjO9zO3hM12R9u03VDgKoXqEtsBS/Ixo
CmMKd3D62WFiunZIL980KwKBgF0W3nzoAC31QaenYBg5qxZgTTTDMkacNT0Dv62J
DjNjdHLdgJFwx4V7tkYf+emvxo+oIMNIuNjgyZHJdJ6MJ1OGOZt87CHS9ttvXMld
BMXxw0HnONO+ZMK5LLgLnZBnqkDKpuS20DdOmYLPQmBVIhHjyKXVpNHzhnS9URnc
/YmhAoGBAJPVtrTlfBGVK18b3zp108YOPf0nZKkhVKaCT+mKoPqTcMJlepUJFTpT
72iDfeuCvLqYG6IuNNtkPW24n91l99MtZodZSmyLP8ez8Lluw1zusQ+FYVgqQxfP
cMKRfSg5wH25RYBGMeNpON1AxTENJfaIN41jnQ1OwwTId1dY3LLO
-----END RSA PRIVATE KEY-----" >> /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa


## change SSH port to 33077 and only listen to IPv4
echo "Updating SSHd details"
sed -i 's/#Port 22/Port 33077/' /etc/ssh/sshd_config
sed -i 's/#AddressFamily any/AddressFamily inet/' /etc/ssh/sshd_config
/etc/init.d/ssh restart > /dev/null


## set controller hostname
echo "Setting hostname"
echo 'zeus-controller' > /etc/hostname
echo "127.0.0.1       zeus-controller" >> /etc/hosts


## make zeus folders
echo "Installing ZEUS"
mkdir /zeus
cd /zeus


## build the config file with site api key
touch /zeus/global_vars.php
echo "\n\n"
echo "Please enter your ZEUS Site API Key:"

read site_api_key

echo '<?php

$config['"'"api_key"'"'] = '"'$site_api_key';" > /zeus/global_vars.php


## get the zeus files
git clone ssh://git@github.com/whittinghamj/deltacolo_zeus_controller.git --quiet
mv deltacolo_zeus_controller controller
cp global_vars.php controller/
crontab controller/crontab.txt

## reboot
reboot
