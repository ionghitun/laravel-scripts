#!/bin/bash
echo "*** Stopping... ***"

cd scripts/local

export STACK_NAME=$(grep -oP '^STACK_NAME=\K.*' .env)

docker compose -p "$STACK_NAME" down

echo "*** Stopped ***"
