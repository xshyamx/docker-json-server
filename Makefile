.PHONY: build stop run version files server

IMAGE_NAME := json-server

build:
	docker build -t ${IMAGE_NAME} .

stop:
	docker rm -f ${IMAGE_NAME}

run:
	docker run -d \
  --name ${IMAGE_NAME} \
  -v `pwd`/db.json:/tmp/db.json \
  -v `pwd`/routes.json:/tmp/routes.json \
  -e DB_JSON=/tmp/db.json \
  -e ROUTES_JSON=/tmp/routes.json \
  -p 3000:3000 \
  ${IMAGE_NAME} -d 1000

version:
	docker run --rm \
  ${IMAGE_NAME} -v

files:
	docker run -d \
  --name ${IMAGE_NAME} \
  -e SEED_JS=/sample/seed.js \
  -p 3000:3000 \
  ${IMAGE_NAME}

server:
	docker run -d \
  --name ${IMAGE_NAME} \
  -v `pwd`/server.js:/app/server.js \
  -p 3000:3000 \
  ${IMAGE_NAME}
  
shell:
	docker run --rm \
  -it --entrypoint=/bin/bash \
  ${IMAGE_NAME}
