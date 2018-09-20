#!/bin/bash

SSHPORT=$(sshd -T | head -n 1 | awk '{print $2}')

echo "SSHPORT = " $SSHPORT;