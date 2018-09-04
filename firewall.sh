#!/bin/bash


## FIREWALL clean up
iptables -F
iptables -t nat -F
iptables -X

