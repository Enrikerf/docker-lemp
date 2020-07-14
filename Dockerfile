FROM php:7.4.7-fpm-alpine3.12 AS dev

WORKDIR /app

RUN apk add --update
RUN apk add --no-cache $PHPIZE_DEPS
RUN apk add libmemcached-dev zlib-dev vim icu-dev g++ wget git zip unzip openssh
RUN apk add libpng-dev jpeg-dev jpeg-dev freetype-dev libwebp-dev libjpeg-turbo-dev libxpm-dev php7-exif libxml2-dev
RUN apk add sqlite-dev sqlite

#RUN pecl install xdebug
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

RUN docker-php-ext-configure intl
RUN docker-php-ext-configure opcache
RUN docker-php-ext-configure gd --with-freetype --with-jpeg

#RUN docker-php-ext-enable xdebug
RUN docker-php-ext-enable redis
RUN docker-php-ext-enable memcached
RUN docker-php-ext-enable memcache

COPY ./docker/php-fpm/php.ini /etc/php/7.4/php.ini
COPY ./docker/php-fpm/php-fpm-pool.conf /etc/php/7.4/pool.d/www.conf

ENV APP_ENV=dev

## Install composer
RUN wget https://getcomposer.org/installer && \
    php installer --install-dir=/usr/local/bin/ --filename=composer && \
    rm installer && \
    composer global require hirak/prestissimo

# Test image --------------------------------------------
FROM dev AS test

## Install application dependencies
RUN composer install --no-interaction --optimize-autoloader

## Change files owner to php-fpm default user
RUN chown -R www-data:www-data .

# Prod image --------------------------------------------
FROM test AS prod

ENV APP_ENV=prod

## Remove dev dependencies
RUN composer install --no-dev --no-interaction --optimize-autoloader

## Disable xdebug on production
RUN rm /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

## Cleanup
RUN apk del dev-deps && \
    composer global remove hirak/prestissimo && \
    rm /usr/local/bin/composer