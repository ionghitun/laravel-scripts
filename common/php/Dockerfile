ARG PHP_IMAGE_VERSION=php:8.4-fpm
FROM ${PHP_IMAGE_VERSION}

USER root

ARG USER_ID=1000
ARG GROUP_ID=1000
ARG APP_USER=appuser
ARG NODE_VERSION=22
ARG INSTALL_XDEBUG=false

RUN set -eux; \
    EXISTING_USER=$(getent passwd "$USER_ID" | cut -d: -f1 || true); \
    EXISTING_GROUP=$(getent group "$GROUP_ID" | cut -d: -f1 || true); \
    if [ -n "$EXISTING_USER" ]; then \
        echo "User with UID $USER_ID already exists: $EXISTING_USER. Renaming to $APP_USER."; \
        usermod -l "$APP_USER" "$EXISTING_USER" || true; \
    else \
        if [ -z "$EXISTING_GROUP" ]; then \
            groupadd -g "$GROUP_ID" "$APP_USER"; \
        fi; \
        useradd -m -u "$USER_ID" -g "$GROUP_ID" -s /bin/bash "$APP_USER"; \
    fi; \
    mkdir -p /home/"$APP_USER" /var/log/supervisor /var/run /app; \
    chown -R "$APP_USER:$GROUP_ID" /home/"$APP_USER" /var/log/supervisor /var/run /app; \
    touch /var/run/supervisord.pid \
    chown "$APP_USER:$GROUP_ID" /var/run/supervisord.pid;

RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
    set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        zip unzip curl ca-certificates tzdata \
        supervisor \
        libonig-dev libicu-dev libxml2-dev libzip-dev \
        libjpeg62-turbo-dev libpng-dev libfreetype6-dev \
        libmagickwand-dev imagemagick \
        libsodium-dev zlib1g-dev g++; \
    rm -rf /var/lib/apt/lists/*

ENV NODE_OPTIONS="--max-old-space-size=2048"
RUN set -eux; \
    curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash -; \
    apt-get update && apt-get install -y --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/*; \
    corepack enable || true

RUN set -eux; \
    docker-php-ext-configure gd --with-freetype --with-jpeg; \
    docker-php-ext-install -j"$(nproc)" \
      intl zip gd exif mbstring bcmath pcntl soap pdo_mysql sockets gettext opcache sodium

RUN set -eux; \
    pecl channel-update pecl.php.net; \
    pecl install redis; \
    docker-php-ext-enable redis; \
    pecl install imagick; \
    docker-php-ext-enable imagick; \
    if [ "$INSTALL_XDEBUG" = "true" ]; then pecl install xdebug && docker-php-ext-enable xdebug; fi

RUN set -eux; \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

USER ${APP_USER}
ENV COMPOSER_HOME="/home/${APP_USER}/.composer"
ENV PATH="$COMPOSER_HOME/vendor/bin:$PATH"
WORKDIR /app

HEALTHCHECK --interval=30s --timeout=3s --retries=5 CMD php -v || exit 1

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
