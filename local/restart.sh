#!/bin/sh
echo
echo "===== Restarting... ====="
echo

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
cd "$SCRIPT_DIR" || exit
docker compose restart

echo
echo "===== Done! ====="
echo
