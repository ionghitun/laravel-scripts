#!/bin/sh
echo
echo "===== Stopping... ====="
echo

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
cd "$SCRIPT_DIR" || exit
docker compose down

echo
echo "===== Done! ====="
echo
