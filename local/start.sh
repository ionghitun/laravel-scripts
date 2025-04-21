#!/bin/sh
echo
echo "===== Starting... ====="
echo

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
cd "$SCRIPT_DIR" || exit
docker compose up -d

echo
echo "===== Done! ====="
echo
