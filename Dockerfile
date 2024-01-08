FROM php:8.2-alpine

# Install PHP modules and clean up
RUN apk add --no-cache $PHPIZE_DEPS \
    imagemagick-dev icu-dev zlib-dev jpeg-dev libpng-dev libpq-dev libzip-dev postgresql-dev libgomp linux-headers; \
    docker-php-ext-configure gd --with-jpeg; \
    docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql; \
    docker-php-ext-install intl pcntl gd exif zip mysqli pgsql pdo pdo_mysql pdo_pgsql bcmath opcache; \
    pecl install xdebug; \
    docker-php-ext-enable xdebug; \
    echo "xdebug.mode=coverage" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    pecl install imagick; \
    docker-php-ext-enable imagick; \
    pecl install redis; \
    docker-php-ext-enable 'redis.so'; \
    apk del $PHPIZE_DEPS; \
    rm -rf /tmp/pear;

# Install other dependencies, including Chromium
RUN apk add --no-cache git curl sqlite \
chromium chromium-chromedriver \
nodejs npm mariadb-client postgresql-client ncdu openssh-client;