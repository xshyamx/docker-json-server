FROM node:latest
MAINTAINER Leon Grünewald <leon.gruenewald@kreativrudel.de>

RUN npm install -g json-server

WORKDIR /data-server
RUN npm install json-server
RUN echo "" > sevrer.js

WORKDIR /data
VOLUME /data

EXPOSE 80
ADD run.sh /run.sh
ENTRYPOINT ["bash", "/run.sh"]
CMD []
