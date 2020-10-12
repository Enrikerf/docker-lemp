# Docker images for LEMP stack

>if you are on github: the goal of this repository is to hold the images for his utilisation in others docker-composer or by itself,the docker-compose on this repository is for developing and documentation. To see the docker images names goes to DockerHub: https://hub.docker.com/u/enrikerf

An example of use:

```
version: "3.0"

services:
  nginx:
    image: enrikerf/nginx:latest
    depends_on:
      - php-fpm
    ports:
      - 80:80
      - 9009:9009 # for xdebug
  php-fpm:
    image: enrikerf/php-fpm-xdebug:latest
    depends_on:
      - mysql
    ports:
      - "9000:9000"
    volumes:
      - ./app:/var/www/app
  mysql:
    image: mysql:8.0
    ports:
      - "127.0.0.1:3306:3306"
    environment:
      MYSQL_DATABASE: $MYSQL_DATABASE
      MYSQL_ROOT_PASSWORD: $MYSQL_ROOT_PASSWORD
      MYSQL_USER: $MYSQL_USER
      MYSQL_PASSWORD: $MYSQL_PASSWORD
    command:
      [
        "mysqld",
        "--character-set-server=utf8mb4",
        "--collation-server=utf8mb4_unicode_ci",
        "--default-authentication-plugin=mysql_native_password",
      ]
    volumes:
      - ./docker/mysql/data:/var/lib/mysql:rw
```

Nginx image
===========

It is important to notice that despite you can set your volume for your code on Php-fpm image, 
the Nginx image will be looking in the location that has been settled in the example. You can change de place on your 
local machine but de path inside de container must remain at the same place or you'll need to rebuild the image on your own.

> path_to_your_code:/var/www/app

you can't chage "/var/www/app"

PHP-FPM image
=============
the dockerfile of php-fpm support more configuration, if it is needed download the dockerfile and create a new image
* ARG DOCKER_PHP_ENABLE_APCU
* ARG DOCKER_PHP_ENABLE_COMPOSER
* ARG DOCKER_PHP_ENABLE_LDAP
* ARG DOCKER_PHP_ENABLE_MEMCACHED
* ARG DOCKER_PHP_ENABLE_MONGODB
* ARG DOCKER_PHP_ENABLE_MYSQL
* ARG DOCKER_PHP_ENABLE_POSTGRESQL
* ARG DOCKER_PHP_ENABLE_REDIS
* ARG DOCKER_PHP_ENABLE_SYMFONY
* ARG DOCKER_PHP_ENABLE_XDEBUG

To build this new image you can do it by:
* building a new image through your own docker-compose and passing ARGS

```
version: "3.0"

services:
  php-fpm:
    build:
      context: ./docker/php-fpm
      dockerfile: Dockerfile
      args:
        DOCKER_PHP_ENABLE_APCU: "on"
        DOCKER_PHP_ENABLE_COMPOSER: "on"
        DOCKER_PHP_ENABLE_EXIF: "off"
        DOCKER_PHP_ENABLE_IMAGICK: "off"
        DOCKER_PHP_ENABLE_LDAP: "off"
        DOCKER_PHP_ENABLE_MEMCACHED: "off"
        DOCKER_PHP_ENABLE_MONGODB: "off"
        DOCKER_PHP_ENABLE_MYSQL: "on"
        DOCKER_PHP_ENABLE_POSTGRESQL: "off"
        DOCKER_PHP_ENABLE_REDIS: "on"
        DOCKER_PHP_ENABLE_SYMFONY: "on"
        DOCKER_PHP_ENABLE_XDEBUG: "on"
    depends_on:
      - mysql
    ports:
      - "9000:9000"
    volumes:
      - ./app:/var/www/app
´
```

> TIPS: see used Dockerfile on: https://github.com/Enrikerf/docker-lemp/blob/master/docker/php-fpm/Dockerfile

* creating your own repository in docker hub (with auto-build ): In this case you must to remember adding the environment variables on the autobuild and remember to create ./hooks/build file to rewrite the build command to:

```
#!/bin/bash
docker build --build-arg DOCKER_PHP_ENABLE_APCU=$DOCKER_PHP_ENABLE_APCU --build-arg DOCKER_PHP_ENABLE_COMPOSER=$DOCKER_PHP_ENABLE_COMPOSER --build-arg DOCKER_PHP_ENABLE_LDAP=$DOCKER_PHP_ENABLE_LDAP --build-arg DOCKER_PHP_ENABLE_MEMCACHED=$DOCKER_PHP_ENABLE_MEMCACHED --build-arg DOCKER_PHP_ENABLE_MONGODB=$DOCKER_PHP_ENABLE_MONGODB --build-arg DOCKER_PHP_ENABLE_MYSQL=$DOCKER_PHP_ENABLE_MYSQL --build-arg DOCKER_PHP_ENABLE_POSTGRESQL=$DOCKER_PHP_ENABLE_POSTGRESQL --build-arg DOCKER_PHP_ENABLE_REDIS=$DOCKER_PHP_ENABLE_REDIS --build-arg DOCKER_PHP_ENABLE_SYMFONY=$DOCKER_PHP_ENABLE_SYMFONY --build-arg DOCKER_PHP_ENABLE_XDEBUG=$DOCKER_PHP_ENABLE_XDEBUG -f $DOCKERFILE_PATH -t $IMAGE_NAME .
```

* building the image on local and pushing to docker hub


