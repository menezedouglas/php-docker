ARG PHP_VERSION=7.4
ARG NODE_VERSION=18

FROM node:${NODE_VERSION}-bullseye AS node_base
# Habilita os shims do corepack (yarn/pnpm) sem baixar pacotes
RUN corepack enable

ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli

# Copia Node, npm, npx, corepack, yarn shim e módulos globais do stage node_base
COPY --from=node_base /usr/local/bin/node  /usr/local/bin/node
COPY --from=node_base /usr/local/bin/npm   /usr/local/bin/npm
COPY --from=node_base /usr/local/bin/npx   /usr/local/bin/npx
COPY --from=node_base /usr/local/bin/corepack /usr/local/bin/corepack
COPY --from=node_base /usr/local/bin/yarn  /usr/local/bin/yarn
COPY --from=node_base /usr/local/lib/node_modules /usr/local/lib/node_modules

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    unzip \
    curl \
    zip \
    vim \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
  && docker-php-ext-install pdo_mysql mbstring zip gd pcntl soap \
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
  && composer global require laravel/installer \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Adiciona binários globais do Composer ao PATH
ENV PATH="/root/.composer/vendor/bin:${PATH}"

WORKDIR /var/www

CMD ["sleep", "infinity"]
