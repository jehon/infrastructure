
FROM debian:testing

ADD . /

RUN --mount=type=cache,target=/var/cache/apt /setup-dev.sh
