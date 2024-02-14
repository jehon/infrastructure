
FROM debian:stable

ADD . /

RUN --mount=type=cache,target=/var/cache/apt .devcontainer/setup.sh
