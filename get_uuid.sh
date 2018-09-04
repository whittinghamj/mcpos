#!/bin/bash

OUTPUT="$(dmidecode -s system-uuid)"
echo "System UUID: ${OUTPUT}"