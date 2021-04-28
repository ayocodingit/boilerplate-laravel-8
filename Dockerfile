FROM alpine:3.11

LABEL Maintainer="Firman Ayocoding <ayocodingit@gmail.com>"

ADD https://dl.bintray.com/php-alpine/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub
# make sure you can use HTTPS
RUN apk --update add ca-certificates

RUN echo "https://dl.bintray.com/php-alpine/v3.11/php-8.0" >> /etc/apk/repositories

# Install packages
RUN apk add php8 \
    php8-common \
    php8-fpm \
    php8-opcache \
    php8-ctype \
    php8-curl \
    php8-dom \
    php8-iconv \
    php8-intl \
    php8-mbstring \
    php8-pdo_mysql \
    php8-pdo_sqlite \
    php8-openssl \
    php8-redis \
    php8-session \
    php8-zlib \
    php8-zip \
    php8-sqlite3 \
    php8-gd \
    php8-phar \
    php8-xml \
    php8-xmlreader \
    php8-sockets \
    php8-sodium \
    php8-pcntl \
    php8-posix \
    php8-dev \
    nginx \
    supervisor


# Fix iconv issue when generate pdf
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
# https://github.com/codecasts/php-alpine/issues/21
RUN ln -s /usr/bin/php8 /usr/bin/php

# Fix zlib not found when adding fix iconv
COPY docker-config/php-module/00_zlib.ini /etc/php8/conf.d/00_zlib.ini
COPY docker-config/php-module/zlib.so /usr/lib/php8/modules/zlib.so

RUN chmod -R 777 /usr/lib/php8/modules/zlib.so
# Configure nginx
COPY docker-config/nginx.conf /etc/nginx/nginx.conf

# Remove default server definition
RUN rm /etc/nginx/conf.d/default.conf

# Configure PHP-FPM
COPY docker-config/fpm-pool.conf /etc/php8/php-fpm.d/www.conf
COPY docker-config/php.ini /etc/php8/conf.d/custom.ini

# Configure supervisord
COPY docker-config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup document root
RUN mkdir -p /var/www/html

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www/html && \
  chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /var/log/nginx

# Switch to use a non-root user from here on
USER nobody
# Add application
WORKDIR /var/www/html
COPY --chown=nobody . /var/www/html/
RUN chmod +x docker-config/docker-entrypoint.sh
# Install composer from the official image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
# Run composer install to install the dependencies
RUN composer install --no-cache --prefer-dist --optimize-autoloader --no-interaction --no-progress && \
    composer dump-autoload --optimize


RUN php -r "file_exists('.env') || copy('.env.example', '.env');"
RUN php artisan key:generate
RUN php artisan optimize

ARG DOCKER_APP
ENV DOCKER_APP $DOCKER_APP

ARG OCTANE_WORKER
ENV OCTANE_WORKER $OCTANE_WORKER
# Expose the port nginx is reachable on
EXPOSE 8080

RUN ./vendor/bin/rr get-binary

RUN chmod u+x rr
# Let supervisord start nginx & php-fpm
ENTRYPOINT [ "docker-config/docker-entrypoint.sh" ]
