#!/bin/sh
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
cd "$SCRIPT_DIR" || exit

echo
printf "Do you want to update images before rebuilding? (y/n) [default: y]: "
read UPDATE_IMAGES
UPDATE_IMAGES=${UPDATE_IMAGES:-y}

if [ "$UPDATE_IMAGES" = "y" ] || [ "$UPDATE_IMAGES" = "Y" ]; then
    echo
    echo "===== Updating images... ====="
    echo

    PHP_IMAGE_VERSION=$(grep -oP '^PHP_IMAGE_VERSION=\K.*' .env)
    MYSQL_IMAGE_VERSION=$(grep -oP '^MYSQL_IMAGE_VERSION=\K.*' .env)
    REDIS_IMAGE_VERSION=$(grep -oP '^REDIS_IMAGE_VERSION=\K.*' .env)

    docker pull nginx
    docker pull "$PHP_IMAGE_VERSION"
    docker pull "$MYSQL_IMAGE_VERSION"
    docker pull "$REDIS_IMAGE_VERSION"
fi

echo
echo "===== Building and starting containers... ====="
echo

docker compose build --no-cache
docker compose up -d

echo
echo "===== Done! ====="
echo
