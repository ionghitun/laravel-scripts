#!/bin/sh
echo
echo "===== Starting... ====="
echo

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
cd "$SCRIPT_DIR" || exit
if command -v docker-compose >/dev/null 2>&1; then
    docker-compose up -d
else
    docker compose up -d
fi

echo
echo "===== Done! ====="
echo
