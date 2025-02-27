#!/bin/bash
echo "Started deploy"

cd scripts/local
export STACK_NAME=$(grep -oP '^STACK_NAME=\K.*' .env)

docker compose up -d

docker exec ${STACK_NAME}-php bash -c "composer install"
docker exec ${STACK_NAME}-php bash -c "php artisan optimize:clear"
docker exec ${STACK_NAME}-php bash -c "php artisan migrate --seed"
docker exec ${STACK_NAME}-php bash -c "npm ci"
docker exec ${STACK_NAME}-php bash -c "npm run build"

echo "Finished deploy"
