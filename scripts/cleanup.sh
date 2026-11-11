#!/usr/bin/env bash

set -euo pipefail

if [[ $# -gt 3 ]]; then
    echo "Usage: $0 [backup_directory] [retention_days] [--apply]"
    exit 1
fi

BACKUP_DIR="${1:-$HOME/backups}"
RETENTION_DAYS="${2:-7}"
APPLY=false

if [[ $# -eq 3 ]]; then
    if [[ "$3" != "--apply" ]]; then
        echo "ERROR: Unknown option: $3"
        exit 1
    fi

    APPLY=true
fi

if [[ ! -d "$BACKUP_DIR" ]]; then
    echo "ERROR: Backup directory does not exist: $BACKUP_DIR"
    exit 1
fi

if [[ ! "$RETENTION_DAYS" =~ ^[0-9]+$ ]] || [[ "$RETENTION_DAYS" -lt 1 ]]; then
    echo "ERROR: Retention days must be a positive integer."
    exit 1
fi

BACKUP_DIR="$(cd "$BACKUP_DIR" && pwd -P)"

echo "================================"
echo "       BACKUP CLEANUP"
echo "================================"
echo ""
echo "Scanning backup directory..."
echo "Backup directory: $BACKUP_DIR"
echo "Retention period: $RETENTION_DAYS days"
echo ""

OLD_BACKUPS=$(find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +"$RETENTION_DAYS" -print)

if [[ -z "$OLD_BACKUPS" ]]; then
    echo "No old backups found."
    exit 0
fi

echo "Old backups found:"
printf '%s\n' "$OLD_BACKUPS"

if [[ "$APPLY" == false ]]; then
    echo ""
    echo "DRY RUN: No files were deleted."
    echo "Use --apply to delete old backups."
    exit 0
fi

echo ""
echo "Deleting old backups..."

while IFS= read -r BACKUP_FILE; do
    if [[ -n "$BACKUP_FILE" ]]; then
        rm -- "$BACKUP_FILE"
        echo "Deleted: $BACKUP_FILE"
    fi
done <<< "$OLD_BACKUPS"

echo ""
echo "Cleanup completed successfully."
