#!/bin/bash

rm -rf /mcp/*.loc

# nvidia vars
export GPU_FORCE_64BIT_PTR=0
export GPU_MAX_HEAP_SIZE=100
export DISPLAY=:0
export GPU_MAX_ALLOC_PRECENT=100
export GPU_USE_SYNC_OBJECTS=0
# export GPU_USE_SYNC_OBJECTS=1
export GPU_SINGLE_ALLOC_PERCENT=100