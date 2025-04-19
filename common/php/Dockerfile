ARG PHP_IMAGE_VERSION=php:8.4-fpm
FROM ${PHP_IMAGE_VERSION}

USER root

ARG USER_ID=1000
ARG GROUP_ID=1000

RUN userdel -f www-data \
    && getent group www-data && groupdel www-data || true \
    && groupadd -g ${GROUP_ID} www-data \
    && useradd -l -u ${USER_ID} -g www-data www-data \
    && install -d -m 0755 -o www-data -g www-data /home/www-data \
    && mkdir /var/log/supervisor \
    && touch /var/run/supervisord.pid \
    && chown -R www-data:www-data /home/www-data /var/log/supervisor /var/run /var/www

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
             supervisor \
             git \
             zip \
             unzip \
             nano \
             curl \
             default-mysql-client cron \
             zlib1g-dev libicu-dev g++ libxml2-dev libmcrypt-dev libzip-dev libmagickwand-dev imagemagick \
        && rm -rf /var/lib/apt/lists/* \
    && pecl update-channels \
    && export EDITOR="/usr/bin/nano"

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN docker-php-ext-install intl && docker-php-ext-configure intl
RUN pecl install redis && docker-php-ext-enable redis
RUN set -ex \
    && curl -fsSL 'https://pecl.php.net/get/imagick-3.7.0.tgz' -o imagick.tar.gz \
    && mkdir -p imagick \
    && tar -xf imagick.tar.gz -C imagick --strip-components=1 \
    && rm imagick.tar.gz \
    && ( \
        cd imagick \
        && phpize \
        && ./configure \
        && make -j "$(nproc)" \
        && make install \
    ) \
    && rm -r imagick \
    && docker-php-ext-enable imagick
RUN docker-php-ext-install gd && docker-php-ext-configure gd --with-freetype --with-jpeg
RUN pecl install xdebug && docker-php-ext-enable xdebug

RUN docker-php-ext-install zip exif pcntl bcmath soap pdo_mysql sockets gettext

ARG NODE_VERSION=22
RUN curl -SLO https://deb.nodesource.com/nsolid_setup_deb.sh \
    && chmod 500 nsolid_setup_deb.sh \
    && ./nsolid_setup_deb.sh ${NODE_VERSION} \
    && apt-get install -y nodejs \
    && npm update -g

ADD ./scripts/common/php/crontab /etc/cron.d/laravel-cron
RUN crontab -u www-data /etc/cron.d/laravel-cron

RUN usermod -a -G crontab www-data \
    && chmod gu+s /usr/sbin/cron

RUN python3 -c "import socket as s; sock = s.socket(s.AF_UNIX); sock.bind('/dev/shm/supervisor.sock')"

USER www-data

RUN echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

WORKDIR /var/www
