FROM php:7.4.13-fpm

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

# gd extension from https://hub.docker.com/_/php
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd
# ----------------------------------------------

RUN docker-php-ext-configure opcache --enable-opcache

RUN docker-php-ext-install pdo_mysql

RUN docker-php-ext-install fileinfo

RUN pecl install apcu && docker-php-ext-enable apcu

RUN apt-get install -y unzip zlib1g-dev libzip-dev && docker-php-ext-configure zip && docker-php-ext-install zip

RUN apt-get install -y libssl-dev pkg-config
RUN pecl install mongodb && docker-php-ext-enable mongodb

RUN pecl install xdebug && docker-php-ext-enable xdebug

ADD etc/php/php.ini "$PHP_INI_DIR/php.ini"
ADD etc/php/conf.d "$PHP_INI_DIR/conf.d"
ADD etc/php-fpm.d/www.conf "/usr/local/etc/php-fpm.d/www.conf"


WORKDIR /var/www/app