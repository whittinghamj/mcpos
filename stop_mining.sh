#!/bin/bash
kill $(ps aux | grep 'mcp' | awk '{print $2}') > /dev/null 2>&1