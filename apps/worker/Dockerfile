FROM node:22.23-alpine3.23

RUN apk upgrade --no-cache && \
    apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/main --upgrade libcrypto3 libssl3 musl musl-utils && \
    apk --no-cache add curl && \
    npm i pm2@6.0.14 -g && \
    rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx

ENV CI=true
ENV NODE_ENV=production
ENV NEW_RELIC_NO_CONFIG_FILE=true
ENV NX_DAEMON=false

USER 1000
WORKDIR /usr/src/app

# Copy pre-built dist and source
COPY --chown=1000:1000 apps/worker/dist ./apps/worker/dist
COPY --chown=1000:1000 apps/worker/src/.example.env ./apps/worker/dist/.env
COPY --chown=1000:1000 apps/worker/src/.env.production ./apps/worker/dist/.env.production

WORKDIR /usr/src/app/apps/worker

ENTRYPOINT [ "sh", "-c", "pm2-runtime start dist/main.js -i ${PM2_INSTANCES:-1}" ]
