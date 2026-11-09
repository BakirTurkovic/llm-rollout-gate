#!/usr/bin/env bash

set -euo pipefail

echo "================================"
echo "       SYSTEM INFORMATION"
echo "================================"

echo "Date: $(date)"
echo "Hostname: $(hostname)"
echo "Operating System: $(uname -s)"
echo "Architecture: $(uname -m)"

echo ""
echo "Disk usage:"
df -h /

echo ""
echo "Memory information:"

if [[ "$(uname -s)" == "Darwin" ]]; then
    vm_stat
else
    free -h
fi

echo ""
echo "System information collected."