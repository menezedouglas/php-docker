ARG NODE_VERSION=18
FROM node:${NODE_VERSION}-bullseye

RUN corepack enable && corepack prepare yarn@stable --activate

WORKDIR /var/www

CMD ["bash", "-lc", "sleep infinity"]
