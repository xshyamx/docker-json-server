FROM node:lts-alpine

VOLUME /data

WORKDIR /sample

ADD ./sample .

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/app/node_modules/.bin \
		SERVER_JS=/app/server.js \
		DB_JSON=/data/db.json \
		ROUTES_JSON=/data/routes.json \
		SEED_JS=/data/seed.js \
		HOST=0.0.0.0 \
		PORT=3000

EXPOSE 3000

ADD entrypoint.sh /entrypoint.sh

WORKDIR /app

RUN apk add bash \
		&& npm install json-server

ENTRYPOINT [ "/entrypoint.sh" ]

