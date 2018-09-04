#!/bin/bash

OUTPUT="$(dmidecode -s system-uuid)"
echo "MCP OS ID: ${OUTPUT}"