#!/bin/sh
echo "*** Restarting... ***"

cd scripts/local || exit

STACK_NAME=$(grep -oP '^STACK_NAME=\K.*' .env)

docker compose -p "$STACK_NAME" restart

echo "*** Restarted ***"
