#!/bin/bash

## MCP OS Controller - Update Script (git pull)

cd /mcp/ && git --git-dir=/mcp/.git pull origin master

crontab /mcp/crontab.txt