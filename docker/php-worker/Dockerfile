ARG PHP_VERSION=7.4
FROM php:${PHP_VERSION}-cli

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    unzip \
    curl \
    supervisor \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
  && docker-php-ext-install pdo_mysql mbstring zip gd \
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
  && composer global require laravel/installer \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV PATH="/root/.composer/vendor/bin:${PATH}"

COPY supervisord.conf /etc/supervisor/supervisord.conf

WORKDIR /var/www

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
