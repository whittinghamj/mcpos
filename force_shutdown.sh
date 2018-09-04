#!/bin/bash

# enables sysrq triggers
sudo echo 1 > /proc/sys/kernel/sysrq

# remount the system as ready only
sudo echo u > /proc/sysrq-trigger

sync

#o - Will shut your system off (if configured and supported).
sudo echo o > /proc/sysrq-trigger
