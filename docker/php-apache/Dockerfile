ARG PHP_VERSION=7.4
FROM php:${PHP_VERSION}-apache

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    unzip \
    curl \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
  && docker-php-ext-install pdo_mysql mbstring zip gd \
  && a2enmod rewrite headers \
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
  && composer global require laravel/installer \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV PATH="/root/.composer/vendor/bin:${PATH}"

WORKDIR /var/www
