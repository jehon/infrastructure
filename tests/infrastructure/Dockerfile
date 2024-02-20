
FROM debian:stable

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

ADD . /app

RUN --mount=type=cache,target=/var/cache/apt /app/setup.sh
