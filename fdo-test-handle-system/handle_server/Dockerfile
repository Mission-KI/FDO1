FROM eclipse-temurin:21-jre-alpine

RUN apk add bash

RUN mkdir -p /hs/srv_1

WORKDIR /hs

ARG HANDLE_SERVER_VERSION=9.3.1
ARG HANDLE_SERVER_DIST_URI=https://handle.net/hnr-source/handle-${HANDLE_SERVER_VERSION}-distribution.tar.gz

ADD ${HANDLE_SERVER_DIST_URI} ./handle-distribution.tar.gz

RUN tar -xvzf handle-distribution.tar.gz

WORKDIR /hs/handle-${HANDLE_SERVER_VERSION}

COPY ./run_handle_server.sh ./

COPY ./templates /hs/templates

CMD ["./run_handle_server.sh"]
