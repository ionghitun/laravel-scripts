#!/bin/sh
echo "*** Rebuild start ***"

cd scripts/local || exit

# Prompt user for input
echo "Want to update images before rebuild? (y/n) [default: y]: "
read UPDATE_IMAGES
UPDATE_IMAGES=${UPDATE_IMAGES:-y}

# Check user input in a POSIX-compatible way
if [ "$UPDATE_IMAGES" = "y" ] || [ "$UPDATE_IMAGES" = "Y" ]; then
    PHP_IMAGE_VERSION=$(grep -oP '^PHP_IMAGE_VERSION=\K.*' .env)
    MYSQL_IMAGE_VERSION=$(grep -oP '^MYSQL_IMAGE_VERSION=\K.*' .env)
    REDIS_IMAGE_VERSION=$(grep -oP '^REDIS_IMAGE_VERSION=\K.*' .env)

    docker pull nginx
    docker pull "$PHP_IMAGE_VERSION"
    docker pull "$MYSQL_IMAGE_VERSION"
    docker pull "$REDIS_IMAGE_VERSION"
fi

STACK_NAME=$(grep -oP '^STACK_NAME=\K.*' .env)

echo "*** Rebuilding application ***"
docker compose -p "$STACK_NAME" build --no-cache
docker compose -p "$STACK_NAME" up -d --force-recreate --remove-orphans

echo "*** Rebuild ended ***"
