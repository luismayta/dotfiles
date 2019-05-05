FROM python:3.6.5-alpine

MAINTAINER Luis Mayta <@slovacus>

ARG stage

ENV PACKAGES bash \
        build-base \
        git \
        gcc \
        libc-dev \
        libmagic \
        linux-headers \
        make \
        musl-dev \
        openssl \
        pcre-dev \
        zlib-dev

ADD . /app
WORKDIR /app

RUN apk add --update  \
  $PACKAGES \
  && pip install -r /app/requirements/$stage.txt
