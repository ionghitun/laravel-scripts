#!/bin/sh
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
cd "$SCRIPT_DIR" || exit

COMPOSE_PROJECT_NAME=$(sed -n 's/^COMPOSE_PROJECT_NAME=//p' .env)

echo
printf "Do you want to execute container as root? (y/n) [default: n]: "
read USE_ROOT

if [ "$USE_ROOT" = "y" ] || [ "$USE_ROOT" = "Y" ]; then
    docker exec -u root -it "${COMPOSE_PROJECT_NAME}-php" bash
else
    docker exec -it "${COMPOSE_PROJECT_NAME}-php" bash
fi
