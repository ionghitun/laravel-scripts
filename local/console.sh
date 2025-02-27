#!/bin/bash
cd scripts/local || exit
export STACK_NAME=$(grep -oP '^STACK_NAME=\K.*' .env)

read -p "Want to execute container as root? (y/n) [default: n]: " USE_ROOT

if [[ "$USE_ROOT" =~ ^[Yy]$ ]]; then
    docker exec -u root -it ${STACK_NAME}-php bash
else
    docker exec -it ${STACK_NAME}-php bash
fi
