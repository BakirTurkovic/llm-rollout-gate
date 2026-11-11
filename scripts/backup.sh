#!/usr/bin/env bash

set -euo pipefail

usage() {
    echo "Usage: $0 <source_directory> [backup_directory]"
    exit 1
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
    usage
fi

SOURCE_INPUT="$1"

if [[ ! -d "$SOURCE_INPUT" ]]; then
    echo "ERROR: Source directory does not exist."
    exit 1
fi

SOURCE_DIR="$(cd "$SOURCE_INPUT" && pwd -P)"

if [[ "$SOURCE_DIR" == "/" ]]; then
    echo "ERROR: Cannot back up the root directory."
    exit 1
fi

SOURCE_NAME="$(basename "$SOURCE_DIR")"

BACKUP_DIR="${2:-$HOME/backups}"

mkdir -p "$BACKUP_DIR"
BACKUP_DIR="$(cd "$BACKUP_DIR" && pwd -P)"

case "$BACKUP_DIR/" in
    "$SOURCE_DIR/"*)
        echo "ERROR: Backup directory cannot be inside source directory."
        exit 1
        ;;
esac

if ! command -v tar >/dev/null 2>&1; then
    echo "ERROR: tar is not installed."
    exit 1
fi

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_FILE="${BACKUP_DIR}/${SOURCE_NAME}_${TIMESTAMP}.tar.gz"

if [[ -e "$BACKUP_FILE" ]]; then
    echo "ERROR: Backup file already exists."
    exit 1
fi

echo "Creating backup..."
echo "Source: $SOURCE_DIR"
echo "Destination: $BACKUP_FILE"

if ! tar -czf "$BACKUP_FILE" \
    -C "$(dirname "$SOURCE_DIR")" "$SOURCE_NAME"; then
    rm -f "$BACKUP_FILE"
    echo "ERROR: Backup creation failed."
    exit 1
fi

if ! tar -tzf "$BACKUP_FILE" >/dev/null; then
    rm -f "$BACKUP_FILE"
    echo "ERROR: Backup verification failed."
    exit 1
fi

echo "Backup created and verified successfully."
echo "Backup file: $BACKUP_FILE"

exit 0
