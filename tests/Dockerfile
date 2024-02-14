
FROM debian:stable

ENV DEBIAN_FRONTEND=noninteractive

ADD setup.sh /

RUN --mount=type=cache,target=/var/cache/apt /setup.sh
