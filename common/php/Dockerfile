ARG PHP_IMAGE_VERSION=php:8.4-fpm
FROM ${PHP_IMAGE_VERSION}

USER root

ARG USER_ID=1000
ARG GROUP_ID=1000
ARG APP_USER=appuser
ARG NODE_VERSION=22

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
    chown -R "$APP_USER:$GROUP_ID" /home/"$APP_USER" /var/log/supervisor /var/run /app

RUN apt-get update  \
    && apt-get upgrade -y  \
    && apt-get install -y --no-install-recommends \
        supervisor git zip unzip nano curl ca-certificates \
        default-mysql-client cron zlib1g-dev libicu-dev g++ \
        libxml2-dev libmcrypt-dev libzip-dev libmagickwand-dev imagemagick \
    && curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && npm update -g \
    && rm -rf /var/lib/apt/lists/* \
    && pecl update-channels \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN docker-php-ext-install intl zip exif pcntl bcmath soap pdo_mysql sockets gettext gd \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && pecl install redis xdebug \
    && docker-php-ext-enable redis xdebug \
    && set -ex; \
    curl -fsSL 'https://pecl.php.net/get/imagick-3.7.0.tgz' -o imagick.tar.gz; \
    mkdir -p imagick; \
    tar -xf imagick.tar.gz -C imagick --strip-components=1; \
    rm imagick.tar.gz; \
    ( \
        cd imagick; \
        phpize; \
        ./configure; \
        make -j "$(nproc)"; \
        make install \
    ) && rm -r imagick && docker-php-ext-enable imagick

COPY ./scripts/common/php/crontab /etc/cron.d/laravel-cron
RUN crontab -u ${APP_USER} /etc/cron.d/laravel-cron \
    && usermod -a -G crontab ${APP_USER} \
    && chmod gu+s /usr/sbin/cron

USER ${APP_USER}

ENV COMPOSER_HOME="/home/${APP_USER}/.composer"
ENV PATH="$COMPOSER_HOME/vendor/bin:$PATH"

WORKDIR /app

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
