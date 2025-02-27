#!/bin/bash
echo "*** Rebuild start ***"

cd scripts/local

read -p "Want to update images before rebuild? (y/n) [default: y]: " UPDATE_IMAGES
UPDATE_IMAGES=${UPDATE_IMAGES:-y}

if [[ "$UPDATE_IMAGES" =~ ^[Yy]$ ]]; then
    export PHP_IMAGE_VERSION=$(grep -oP '^PHP_IMAGE_VERSION=\K.*' .env)
    export MYSQL_IMAGE_VERSION=$(grep -oP '^MYSQL_IMAGE_VERSION=\K.*' .env)
    export REDIS_IMAGE_VERSION=$(grep -oP '^REDIS_IMAGE_VERSION=\K.*' .env)

    docker pull nginx
    docker pull "${PHP_IMAGE_VERSION}"
    docker pull "${MYSQL_IMAGE_VERSION}"
    docker pull "${REDIS_IMAGE_VERSION}"
fi

echo "*** Rebuilding application ***"
docker-compose build --no-cache
docker compose up -d --force-recreate --remove-orphans

echo "*** Rebuild ended ***"
