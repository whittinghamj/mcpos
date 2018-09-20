#!/bin/bash

SSHPORT_BITS=$(grep "Port" /etc/ssh/sshd_config) | head -n 1

SSHPORT=$(sed -i "s/Port //g" $SSHPORT_BITS)

echo $SSHPORT;