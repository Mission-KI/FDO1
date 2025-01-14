FROM node:lts-alpine

COPY ./package.json /webui/package.json
COPY ./package-lock.json /webui/package-lock.json

WORKDIR /webui

RUN npm ci --legacy-peer-deps

ENTRYPOINT [""]
