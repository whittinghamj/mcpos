#!/bin/bash

HASHRATE="$(sh /mcp/stats.sh)";
UPTIME="$(uptime | sed -E 's/^[^,]*up *//; s/, *[[:digit:]]* users.*//; s/min/minutes/; s/([[:digit:]]+):0?([[:digit:]]+)/\1 hours, \2 minutes/' )";

echo "Uptime: $UPTIME"
echo "Hashrate: $HASHRATE"

sudo nvidia-smi