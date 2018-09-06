#!/bin/bash


cd /mcp/miners/claymore-dual-amd-nvidia-10.2
sudo nohup ethdcrminer64 -epool eth-us-west1.nanopool.org:9999 -ewal 0x71e377d4b4125e3c548fb8fe4c06db63f710fbc8.worker_1/admin@deltacolo.com -epsw x -mode 1 -ftime 10 > /mcp/logs/miner.log & 