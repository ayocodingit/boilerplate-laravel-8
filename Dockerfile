FROM alpine:3.13

LABEL Maintainer="Firman Ayocoding <ayocodingit@gmail.com>"

ADD https://packages.whatwedo.ch/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub

# make sure you can use HTTPS
RUN apk --update-cache add ca-certificates

# Install packages
RUN apk add php8 \
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
    php8-gd \
    php8-phar \
    php8-fileinfo \
    php8-xml \
    php8-xmlreader \
    php8-simplexml \
    php8-xmlwriter \
    php8-sockets \
    php8-sodium \
    php8-pcntl

# Fix iconv issue when generate pdf
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# https://github.com/codecasts/php-alpine/issues/21
RUN ln -s /usr/bin/php8 /usr/bin/php

# Setup document root
RUN mkdir -p /var/www/html

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www/html

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
ARG OCTANE_WORKER
ARG PORT=8080

ENV DOCKER_APP $DOCKER_APP
ENV OCTANE_WORKER $OCTANE_WORKER
ENV PORT $PORT
# Expose the port nginx is reachable on
EXPOSE $PORT

RUN ./vendor/bin/rr get-binary --location .

RUN chmod u+x rr

# Let supervisord start nginx & php-fpm
ENTRYPOINT [ "docker-config/docker-entrypoint.sh" ]
