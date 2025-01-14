FROM eclipse-temurin:21-jre-alpine

RUN apk add bash
RUN mkdir -p /opt
WORKDIR /opt

ARG CORDRA_VERSION=2.5.2
ARG CORDRA_DIST_URI=https://www.cordra.org/assets/sw/cordra-${CORDRA_VERSION}-distribution.zip
ARG ADMIN_PASS
ARG BASE_URI
ARG PREFIX
ARG HDL_ADMIN_ID
ARG CORDRA_EXTERNAL_ADDRESS

ENV CORDRA_ADMIN_PASS ${ADMIN_PASS}
ENV CORDRA_BASE_URI ${BASE_URI}
ENV CORDRA_PREFIX ${PREFIX}
ENV CORDRA_HDL_ADMIN ${HDL_ADMIN_ID}
ENV CORDRA_EXTERNAL_ADDRESS ${CORDRA_EXTERNAL_ADDRESS}

ADD ${CORDRA_DIST_URI} ./cordra-distribution.zip

RUN unzip cordra-distribution.zip
RUN mv ./cordra-${CORDRA_VERSION} ./cordra

COPY ./wait-for-it.sh ./cordra/
COPY ./data ./cordra/data
COPY ./schema ./cordra/schema

ENTRYPOINT [ "/opt/cordra/startup" ]
