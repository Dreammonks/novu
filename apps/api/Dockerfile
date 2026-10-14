FROM node:22.23-alpine3.23

RUN apk upgrade --no-cache && \
    apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/main --upgrade libcrypto3 libssl3 musl musl-utils && \
    npm --no-update-notifier --no-fund --global install pm2@6.0.14 && \
    rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx

ENV CI=true
ENV NODE_ENV=production
ENV NEW_RELIC_NO_CONFIG_FILE=true
ENV NX_DAEMON=false

USER 1000
WORKDIR /usr/src/app

# Copy pre-built dist and source (symlinks work because repo is mounted)
COPY --chown=1000:1000 apps/api/dist ./apps/api/dist
COPY --chown=1000:1000 apps/api/src/.example.env ./apps/api/dist/.env
COPY --chown=1000:1000 apps/api/src/.env.production ./apps/api/dist/.env.production

# Rewrite metadata.js monorepo paths
RUN if [ -f apps/api/dist/metadata.js ]; then \
      sed -i \
        -e 's|../../../packages/shared/dist|../node_modules/@novu/shared/dist|g' \
        -e 's|../../../libs/application-generic/build|../node_modules/@novu/application-generic/build|g' \
        -e 's|../../../libs/dal/dist|../node_modules/@novu/dal/dist|g' \
        apps/api/dist/metadata.js; \
    fi

WORKDIR /usr/src/app/apps/api

ENTRYPOINT [ "sh", "-c", "pm2-runtime start dist/main.js -i ${PM2_INSTANCES:-1}" ]
