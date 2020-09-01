# Docker images for LEMP stack

the goal of this repository is to hold the images for it utilisation in others docker-composer or by itself, the docker-compose on this repository is for developing and documentation.

To see the docker images names goes to DockerHub: https://hub.docker.com/u/enrikerf

An example of utilization:

```
version: "3.0"

services:
  nginx:
    image: enrikerf/nginx
    depends_on:
      - php-fpm
    ports:
      - 80:80
  php-fpm:
    image: enrikerf/php-fpm:<tagname>
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

remember that tagname of php-fpm it is important to choose the extensions enabled, the options available:
*   php-fpm:xdebug
*   php-fpm:composer
*   php-fpm:xdebug-composer

the dockerfile of php-fpm support more configuration, it it is needed download the dockerfile and create a new image
* ARG DOCKER_PHP_ENABLE_APCU=false
* ARG DOCKER_PHP_ENABLE_COMPOSER=false
* ARG DOCKER_PHP_ENABLE_LDAP=false
* ARG DOCKER_PHP_ENABLE_MEMCACHED=false
* ARG DOCKER_PHP_ENABLE_MONGODB=false
* ARG DOCKER_PHP_ENABLE_MYSQL=false
* ARG DOCKER_PHP_ENABLE_POSTGRESQL=false
* ARG DOCKER_PHP_ENABLE_REDIS=false
* ARG DOCKER_PHP_ENABLE_SYMFONY=false
* ARG DOCKER_PHP_ENABLE_XDEBUG=false
