FROM php:8.2-alpine

# Install PHP modules and clean up
RUN apk add --no-cache $PHPIZE_DEPS \
    imagemagick-dev icu-dev zlib-dev jpeg-dev libpng-dev libpq-dev libzip-dev postgresql-dev libgomp linux-headers; \
    docker-php-ext-configure gd --with-jpeg; \
    docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql; \
    docker-php-ext-install intl pcntl gd exif zip mysqli pgsql pdo pdo_mysql pdo_pgsql bcmath opcache; \
    # { Xdebug workaround
    # --------------------------------
    # pecl install xdebug; \
    # docker-php-ext-enable xdebug; \
    # echo "xdebug.mode=coverage" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    # --------------------------------
    wget https://xdebug.org/files/xdebug-3.2.0.tgz; \
    tar -xzf xdebug-3.2.0.tgz; \
    cd xdebug-3.2.0; \
    phpize; \
    ./configure --enable-xdebug; \
    make; make install; \
    echo $'zend_extension=xdebug\nxdebug.mode=coverage' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    # End Xdebug workaround }
    pecl install imagick; \
    docker-php-ext-enable imagick; \
    pecl install redis; \
    docker-php-ext-enable 'redis.so'; \
    apk del $PHPIZE_DEPS; \
    rm -rf /tmp/pear;

# Install other dependencies
RUN apk add --no-cache git curl sqlite \
nodejs npm mariadb-client postgresql-client ncdu openssh-client; \
npm install --global yarn;