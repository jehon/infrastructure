
FROM debian:stable

ENV DEBIAN_FRONTEND=noninteractive

COPY --from=root . /

COPY --from=publish . /setup

WORKDIR /app
ADD . /app

RUN --mount=type=cache,target=/var/cache/apt /app/setup.sh
