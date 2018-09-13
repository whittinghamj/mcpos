#!/bin/bash
kill $(ps aux | grep '/mcp/miners' | awk '{print $2}') > /dev/null 2>&1
kill $(ps aux | grep 'start_mining.sh' | awk '{print $2}') > /dev/null 2>&1