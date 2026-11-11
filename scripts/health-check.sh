#!/usr/bin/env bash

set -euo pipefail

echo "================================"
echo "          HEALTH CHECK"
echo "================================"

echo ""
echo "Checking disk usage..."

DISK_USAGE=$(df -P / | awk 'NR==2 {gsub(/%/, "", $5); print $5}')

echo "Disk usage: ${DISK_USAGE}%"

THRESHOLD=80
EXIT_CODE=0

if [[ "$DISK_USAGE" -ge "$THRESHOLD" ]]; then
    echo "WARNING: Disk usage is too high!"
    EXIT_CODE=1
else
    echo "OK: Disk usage is normal."
fi

exit "$EXIT_CODE"
