FROM node:22-bookworm-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget curl && \
    rm -rf /var/lib/apt/lists/* /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx

ENV CI=true
ENV NODE_ENV=production
ENV NEW_RELIC_NO_CONFIG_FILE=true
ENV NX_DAEMON=false

USER 1000
WORKDIR /usr/src/app

COPY --chown=1000:1000 deploy ./

ENTRYPOINT [ "node", "dist/main.js" ]
