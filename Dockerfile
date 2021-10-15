FROM node:lts-alpine

RUN apk add bash \
		&& npm install -g json-server

WORKDIR /app

RUN npm install json-server

VOLUME /data

WORKDIR /sample

ADD db.json routes.json seed.js server.js ./

ENV SERVER_JS=/app/server.js \
		DB_JSON=/data/db.json \
		ROUTES_JSON=/data/routes.json \
		SEED_JS=/data/seed.js \
		HOST=0.0.0.0 \
		PORT=3000

EXPOSE 3000

ADD entrypoint.sh /entrypoint.sh

WORKDIR /app

ENTRYPOINT [ "/entrypoint.sh" ]

