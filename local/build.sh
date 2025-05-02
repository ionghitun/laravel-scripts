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

    PHP_IMAGE_VERSION=$(sed -n 's/^PHP_IMAGE_VERSION=//p' .env)
    MYSQL_IMAGE_VERSION=$(sed -n 's/^MYSQL_IMAGE_VERSION=//p' .env)
    REDIS_IMAGE_VERSION=$(sed -n 's/^REDIS_IMAGE_VERSION=//p' .env)

    docker pull nginx
    docker pull "$PHP_IMAGE_VERSION"
    docker pull "$MYSQL_IMAGE_VERSION"
    docker pull "$REDIS_IMAGE_VERSION"
fi

echo
echo "===== Building and starting containers... ====="
echo

if command -v docker-compose >/dev/null 2>&1; then
    docker-compose build --no-cache
    docker-compose up -d
else
    docker compose build --no-cache
    docker compose up -d
fi

echo
echo "===== Done! ====="
echo
