#!/bin/bash
echo "*** Deploy start ***"

cd scripts/local
export STACK_NAME=$(grep -oP '^STACK_NAME=\K.*' .env)

echo "*** Making sure application is up ***"
docker compose -p "$STACK_NAME" up -d

echo "*** Running application scripts ***"
docker exec ${STACK_NAME}-php bash -c "composer install"
docker exec ${STACK_NAME}-php bash -c "php artisan optimize:clear"
docker exec ${STACK_NAME}-php bash -c "php artisan migrate --seed"
docker exec ${STACK_NAME}-php bash -c "npm ci"
docker exec ${STACK_NAME}-php bash -c "npm run build"

echo "*** Deploy ended ***"
