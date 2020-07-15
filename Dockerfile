FROM php:7.4.7-fpm-alpine3.12 AS dev

ENV APP_ENV=dev

RUN apk add --update
RUN apk add --no-cache $PHPIZE_DEPS
RUN apk add libmemcached-dev zlib-dev vim icu-dev g++ wget git zip unzip openssh
RUN apk add libpng-dev jpeg-dev jpeg-dev freetype-dev libwebp-dev libjpeg-turbo-dev libxpm-dev php7-exif libxml2-dev
RUN apk add sqlite-dev sqlite


RUN pecl install redis
RUN pecl install memcached
RUN pecl install memcache

RUN docker-php-ext-install bcmath
RUN docker-php-ext-install opcache
RUN docker-php-ext-install intl
RUN docker-php-ext-install sockets
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install gd
RUN docker-php-ext-install exif
RUN docker-php-ext-install xmlrpc
RUN docker-php-ext-install pcntl

ENV EXT_APCU_VERSION=5.1.17

RUN docker-php-source extract \
    && mkdir -p /usr/src/php/ext/apcu \
    && curl -fsSL https://github.com/krakjoe/apcu/archive/v$EXT_APCU_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/apcu --strip 1 \
    && docker-php-ext-install apcu \
    && docker-php-source delete

RUN docker-php-ext-configure intl
RUN docker-php-ext-configure opcache --enable-opcache
RUN docker-php-ext-configure gd --with-freetype --with-jpeg


RUN docker-php-ext-enable redis
RUN docker-php-ext-enable memcached
RUN docker-php-ext-enable memcache

#RUN pecl install xdebug
#RUN docker-php-ext-enable xdebug

COPY ./php.ini /etc/php/7.4/php.ini
COPY ./php-fpm-pool.conf /etc/php/7.4/pool.d/www.conf

## Install composer
RUN wget https://getcomposer.org/installer && \
    php installer --install-dir=/usr/local/bin/ --filename=composer && \
    rm installer && \
    composer global require hirak/prestissimo

WORKDIR /app

RUN chown -R www-data:www-data .



