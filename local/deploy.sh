#!/bin/sh
echo
echo "===== Deploy started... ====="
echo

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
cd "$SCRIPT_DIR" || exit

echo
echo "===== Making sure application is up ====="
echo

docker compose up -d

echo
echo "===== Running application scripts ====="
echo

COMPOSE_PROJECT_NAME=$(grep -oP '^COMPOSE_PROJECT_NAME=\K.*' .env)

docker exec "${COMPOSE_PROJECT_NAME}-php" bash -c "composer install"
docker exec "${COMPOSE_PROJECT_NAME}-php" bash -c "php artisan optimize:clear"
docker exec "${COMPOSE_PROJECT_NAME}-php" bash -c "php artisan migrate --seed"
docker exec "${COMPOSE_PROJECT_NAME}-php" bash -c "npm ci"
docker exec "${COMPOSE_PROJECT_NAME}-php" bash -c "npm run build"

echo
echo "===== Done! ====="
echo
