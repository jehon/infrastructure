
FROM debian:stable

ENV DEBIAN_FRONTEND=noninteractive

ADD . /

RUN --mount=type=cache,target=/var/cache/apt ./setup.sh
