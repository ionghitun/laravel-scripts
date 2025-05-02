#!/bin/sh
echo
echo "===== Restarting... ====="
echo

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
cd "$SCRIPT_DIR" || exit
if command -v docker-compose >/dev/null 2>&1; then
    docker-compose restart
else
    docker compose restart
fi

echo
echo "===== Done! ====="
echo
