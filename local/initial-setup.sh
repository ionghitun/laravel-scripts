#!/bin/sh
echo "*** Setup start ***"

cd scripts/local || exit

ENV_FILE="./.env"

if [ -f "$ENV_FILE" ]; then
    printf ".env file already exists. Do you want to reset configuration? (y/n) [default: n]: "
    read OVERWRITE_ENV

    OVERWRITE_ENV=${OVERWRITE_ENV:-n}
    case "$OVERWRITE_ENV" in
        [Yy]) ;;
        *) echo "*** Script cancelled ***"; exit 0 ;;
    esac
fi

echo "*** Removing old configuration ***"
if [ -f "docker-compose.yml" ]; then
    STACK_NAME=$(grep '^STACK_NAME=' .env | cut -d '=' -f2)
    docker compose -p "$STACK_NAME" down
fi

if [ ! -f "$ENV_FILE" ] || [ "$OVERWRITE_ENV" = "y" ] || [ "$OVERWRITE_ENV" = "Y" ]; then
    ENV_EXAMPLE=".env.example"
    if [ ! -f "$ENV_EXAMPLE" ]; then
        echo "*** Error: $ENV_EXAMPLE not found! ***"
        exit 1
    fi

    get_default_value() {
        grep "^$1=" "$ENV_EXAMPLE" | cut -d '=' -f2
    }

    rm -f "$ENV_FILE"
    echo "*** Creating new $ENV_FILE file ***"
    touch "$ENV_FILE"

    STACK_NAME=$(get_default_value "STACK_NAME")
    printf "Enter value for STACK_NAME [default: %s]: " "$STACK_NAME"
    read input
    STACK_NAME=${input:-$STACK_NAME}
    echo "STACK_NAME=$STACK_NAME" >> "$ENV_FILE"

    PHP_IMAGE_VERSION=$(get_default_value "PHP_IMAGE_VERSION")
    printf "Enter value for PHP_IMAGE_VERSION [default: %s]: " "$PHP_IMAGE_VERSION"
    read input
    PHP_IMAGE_VERSION=${input:-$PHP_IMAGE_VERSION}
    echo "PHP_IMAGE_VERSION=$PHP_IMAGE_VERSION" >> "$ENV_FILE"

    MYSQL_IMAGE_VERSION=$(get_default_value "MYSQL_IMAGE_VERSION")
    printf "Enter value for MYSQL_IMAGE_VERSION [default: %s]: " "$MYSQL_IMAGE_VERSION"
    read input
    MYSQL_IMAGE_VERSION=${input:-$MYSQL_IMAGE_VERSION}
    echo "MYSQL_IMAGE_VERSION=$MYSQL_IMAGE_VERSION" >> "$ENV_FILE"

    REDIS_IMAGE_VERSION=$(get_default_value "REDIS_IMAGE_VERSION")
    printf "Enter value for REDIS_IMAGE_VERSION [default: %s]: " "$REDIS_IMAGE_VERSION"
    read input
    REDIS_IMAGE_VERSION=${input:-$REDIS_IMAGE_VERSION}
    echo "REDIS_IMAGE_VERSION=$REDIS_IMAGE_VERSION" >> "$ENV_FILE"

    NODE_VERSION=$(get_default_value "NODE_VERSION")
    printf "Enter value for NODE_VERSION [default: %s]: " "$NODE_VERSION"
    read input
    NODE_VERSION=${input:-$NODE_VERSION}
    echo "NODE_VERSION=$NODE_VERSION" >> "$ENV_FILE"

    DOMAIN_HOST=$(get_default_value "DOMAIN_HOST")
    printf "Enter value for DOMAIN_HOST [default: %s]: " "$DOMAIN_HOST"
    read input
    DOMAIN_HOST=${input:-$DOMAIN_HOST}
    echo "DOMAIN_HOST=$DOMAIN_HOST" >> "$ENV_FILE"

    printf "Are you using nginx-proxy with self-signed companion and want to use HTTPS? (y/n) [default: y]: "
    read USE_HTTPS
    USE_HTTPS=${USE_HTTPS:-y}
    if [ "$USE_HTTPS" = "y" ] || [ "$USE_HTTPS" = "Y" ]; then
        SELF_SIGNED_HOST=$DOMAIN_HOST
        echo "SELF_SIGNED_HOST=$SELF_SIGNED_HOST" >> "$ENV_FILE"
    fi

    DOMAIN_EMAIL=$(get_default_value "DOMAIN_EMAIL")
    printf "Enter value for DOMAIN_EMAIL [default: %s]: " "$DOMAIN_EMAIL"
    read input
    DOMAIN_EMAIL=${input:-$DOMAIN_EMAIL}
    echo "DOMAIN_EMAIL=$DOMAIN_EMAIL" >> "$ENV_FILE"

    USER_ID=$(id -u)
    echo "USER_ID=$USER_ID" >> "$ENV_FILE"

    GROUP_ID=$(id -g)
    echo "GROUP_ID=$GROUP_ID" >> "$ENV_FILE"

    MYSQL_ROOT_PASSWORD=$(get_default_value "MYSQL_ROOT_PASSWORD")
    printf "Enter value for MYSQL_ROOT_PASSWORD [default: %s]: " "$MYSQL_ROOT_PASSWORD"
    read input
    MYSQL_ROOT_PASSWORD=${input:-$MYSQL_ROOT_PASSWORD}
    echo "MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD" >> "$ENV_FILE"

    MYSQL_USERNAME=$(get_default_value "MYSQL_USERNAME")
    printf "Enter value for MYSQL_USERNAME [default: %s]: " "$MYSQL_USERNAME"
    read input
    MYSQL_USERNAME=${input:-$MYSQL_USERNAME}
    echo "MYSQL_USERNAME=$MYSQL_USERNAME" >> "$ENV_FILE"

    MYSQL_PASSWORD=$(get_default_value "MYSQL_PASSWORD")
    printf "Enter value for MYSQL_PASSWORD [default: %s]: " "$MYSQL_PASSWORD"
    read input
    MYSQL_PASSWORD=${input:-$MYSQL_PASSWORD}
    echo "MYSQL_PASSWORD=$MYSQL_PASSWORD" >> "$ENV_FILE"

    MYSQL_DATABASE=$(get_default_value "MYSQL_DATABASE")
    printf "Enter value for MYSQL_DATABASE [default: %s]: " "$MYSQL_DATABASE"
    read input
    MYSQL_DATABASE=${input:-$MYSQL_DATABASE}
    echo "MYSQL_DATABASE=$MYSQL_DATABASE" >> "$ENV_FILE"

    MYSQL_EXTERNAL_PORT=$(get_default_value "MYSQL_EXTERNAL_PORT")
    printf "Enter value for MYSQL_EXTERNAL_PORT [default: %s]: " "$MYSQL_EXTERNAL_PORT"
    read input
    MYSQL_EXTERNAL_PORT=${input:-$MYSQL_EXTERNAL_PORT}
    echo "MYSQL_EXTERNAL_PORT=$MYSQL_EXTERNAL_PORT" >> "$ENV_FILE"

    printf "Are you using nginx-proxy and minio and want to set extra host for minio? (y/n) [default: y]: "
    read USE_MINIO
    USE_MINIO=${USE_MINIO:-y}
    if [ "$USE_MINIO" = "y" ] || [ "$USE_MINIO" = "Y" ]; then
        GATEWAY_IP=$(docker network inspect nginx-proxy -f '{{range .IPAM.Config}}{{.Gateway}}{{end}}')

        if [ -n "$GATEWAY_IP" ]; then
            EXTRA_HOST_MINIO=$(get_default_value "EXTRA_HOST_MINIO")
            MINIO_DOMAIN=${EXTRA_HOST_MINIO%%:*}
            printf "Enter value for MINIO_DOMAIN [default: %s]: " "$MINIO_DOMAIN"
            read input
            MINIO_DOMAIN=${input:-$MINIO_DOMAIN}
            echo "EXTRA_HOST_MINIO=$MINIO_DOMAIN:$GATEWAY_IP" >> "$ENV_FILE"
        else
            echo "*** Error: Unable to retrieve Gateway IP for nginx-proxy network ***"
            exit 1
        fi
    fi

    REDIS_PASSWORD=$(get_default_value "REDIS_PASSWORD")
    printf "Enter value for REDIS_PASSWORD [default: %s]: " "$REDIS_PASSWORD"
    read input
    REDIS_PASSWORD=${input:-$REDIS_PASSWORD}
    echo "REDIS_PASSWORD=$REDIS_PASSWORD" >> "$ENV_FILE"

    echo "*** Creating new php.ini file ***"
    cp ../common/example/php.ini.example php.ini

    printf "Do you want to enable and use xdebug? (y/n) [default: y]: "
    read USE_XDEBUG
    USE_XDEBUG=${USE_XDEBUG:-y}
    if [ "$USE_XDEBUG" = "y" ] || [ "$USE_XDEBUG" = "Y" ]; then
        XDEBUG_PORT=$(get_default_value "XDEBUG_PORT")
        printf "Enter Xdebug port [default: %s]: " "$XDEBUG_PORT"
        read input
        XDEBUG_PORT=${input:-$XDEBUG_PORT}
        echo "XDEBUG_PORT=$XDEBUG_PORT" >> "$ENV_FILE"

        sed -i "s/^xdebug.client_port = .*/xdebug.client_port = $XDEBUG_PORT/" php.ini
    else
        sed -i '/xdebug/d' php.ini
    fi
fi

# Load .env variables
set -a
. "$ENV_FILE"
set +a

echo "*** Creating new init/01-databases.sql file ***"
[ -d init ] || mkdir init
cp ../common/example/01-databases.sql.example init/01-databases.sql
sed -i "s/DB_NAME/${MYSQL_DATABASE}/g" init/01-databases.sql

echo "*** Creating new vhost.conf file ***"
cp ../common/example/vhost.conf.example vhost.conf
sed -i "s/DOMAIN_HOST/${DOMAIN_HOST}/g" vhost.conf
sed -i "s/API_SERVICE/${STACK_NAME}-php/g" vhost.conf

echo "*** Creating new docker-compose.yml file ***"
cp ../common/example/docker-compose.yml.example docker-compose.yml
sed -i "s/STACK_NAME/${STACK_NAME}/g" docker-compose.yml

HAS_MINIO=$(grep "^EXTRA_HOST_MINIO=" "$ENV_FILE" | cut -d '=' -f2)
HAS_HTTPS=$(grep "^SELF_SIGNED_HOST=" "$ENV_FILE" | cut -d '=' -f2)
HAS_XDEBUG=$(grep "^XDEBUG_PORT=" "$ENV_FILE" | cut -d '=' -f2)

if [ -z "$HAS_HTTPS" ]; then
    sed -i '/SELF_SIGNED_HOST:/d' docker-compose.yml
fi

if [ -z "$HAS_XDEBUG" ]; then
    sed -i "/${STACK_NAME}-php:/,/networks:/ { /ports:/d; /XDEBUG_PORT/d }" docker-compose.yml
    sed -i '/location \/coverage {/,/}/d' vhost.conf
fi
if [ -z "$HAS_MINIO" ]; then
    sed -i "/${STACK_NAME}-php:/,/networks:/ { /extra_hosts:/d; /host.docker.internal/d; /EXTRA_HOST_MINIO/d }" docker-compose.yml
    sed -i "/${STACK_NAME}-php:/,/${STACK_NAME}-mysql:/ { /nginx-proxy/d }" docker-compose.yml
fi

if [ ! -f ../../.env ]; then
    echo "*** Creating laravel .env file ***"
    cp ../../.env.example ../../.env
fi

echo "*** Creating laravel storage/logs/services folder ***"
[ -d ../../storage/logs/services ] || mkdir ../../storage/logs/services
echo "*\n!.gitignore" > ../../storage/logs/services/.gitignore

if ! grep -Fxq "!/services" ../../storage/logs/.gitignore; then
    echo "!/services" >> ../../storage/logs/.gitignore
fi

if ! grep -Fxq "!/services/.gitignore" ../../storage/logs/.gitignore; then
    echo "!/services/.gitignore" >> ../../storage/logs/.gitignore
fi

printf "Want to update laravel .env with known information? (y/n) [default: y]: "
read UPDATE_LARAVEL_ENV
UPDATE_LARAVEL_ENV=${UPDATE_LARAVEL_ENV:-y}

if [ "$UPDATE_LARAVEL_ENV" = "y" ] || [ "$UPDATE_LARAVEL_ENV" = "Y" ]; then
    if [ -n "$HAS_HTTPS" ]; then
        sed -i "s|^APP_URL=.*|APP_URL=https://${DOMAIN_HOST}|" ../../.env
    else
        sed -i "s|^APP_URL=.*|APP_URL=http://${DOMAIN_HOST}|" ../../.env
    fi

    sed -i "s/^DB_HOST=.*/DB_HOST=$STACK_NAME-mysql/" ../../.env
    sed -i "s/^DB_DATABASE=.*/DB_DATABASE=$MYSQL_DATABASE/" ../../.env
    sed -i "s/^DB_USERNAME=.*/DB_USERNAME=$MYSQL_USERNAME/" ../../.env
    sed -i "s/^DB_PASSWORD=.*/DB_PASSWORD=$MYSQL_PASSWORD/" ../../.env
    sed -i "s/^REDIS_HOST=.*/REDIS_HOST=$STACK_NAME-redis/" ../../.env
    sed -i "s/^REDIS_PASSWORD=.*/REDIS_PASSWORD=$REDIS_PASSWORD/" ../../.env
fi

echo "*** Building application ***"
docker compose -p "$STACK_NAME" build --no-cache
docker compose -p "$STACK_NAME" up -d --force-recreate --remove-orphans

echo "*** Waiting for containers to be ready ***"
until docker logs "${STACK_NAME}-mysql" 2>&1 | grep -q "mysqld: ready for connections"; do
  sleep 2
done

echo "*** Running application scripts ***"
docker exec "${STACK_NAME}-php" bash -c "composer install"
docker exec "${STACK_NAME}-php" bash -c "php artisan key:generate"
docker exec "${STACK_NAME}-php" bash -c "php artisan optimize:clear"
docker exec "${STACK_NAME}-php" bash -c "php artisan migrate --seed"
docker exec "${STACK_NAME}-php" bash -c "npm install"
docker exec "${STACK_NAME}-php" bash -c "npm run build"
docker exec "${STACK_NAME}-php" bash -c "php artisan storage:link"

echo "*** Setup ended ***"
