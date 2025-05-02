#!/bin/sh
echo
echo "===== Stopping... ====="
echo

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
cd "$SCRIPT_DIR" || exit
if command -v docker-compose >/dev/null 2>&1; then
    docker-compose down
else
    docker compose down
fi

echo
echo "===== Done! ====="
echo
