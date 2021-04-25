FROM alpine:3.13

LABEL Maintainer="Firman Ayocoding <ayocodingit@gmail.com>"

ADD https://dl.bintray.com/php-alpine/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub

# Install packages
RUN apk add ca-certificates \
    nano \
    php8 \
    php8-fpm \
    php8-json \
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
    php8-zip \
    php8-zlib \
    php8-sqlite3 \
    php8-tokenizer \
    php8-fpm \
    php8-opcache \
    php8-openssl \
    php8-gd \
    php8-phar \
    php8-fileinfo \
    php8-xml \
    php8-xmlreader \
    php8-simplexml \
    php8-xmlwriter \
    nginx \
    supervisor \
    composer

# Fix iconv issue when generate pdf
RUN apk add --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# https://github.com/codecasts/php-alpine/issues/21
RUN rm /usr/bin/php
RUN ln -s /usr/bin/php8 /usr/bin/php

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

# Run composer install to install the dependencies
RUN composer install --no-cache --no-scripts --prefer-dist --no-interaction --no-progress

# Expose the port nginx is reachable on
EXPOSE 8080

# Let supervisord start nginx & php-fpm
ENTRYPOINT [ "docker-config/docker-entrypoint.sh" ]