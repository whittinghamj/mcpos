#!/bin/bash

HASHRATE="$(sh /mcp/stats.sh)";

echo "Hashrate: $HASHRATE"

sudo nvidia-smi