#!/bin/bash
kill $(ps aux | grep 'mine' | awk '{print $2}')