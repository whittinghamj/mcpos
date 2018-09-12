#!/bin/bash

if pidof -x "stratum" >/dev/null; then
    echo "Miner is already running"
fi