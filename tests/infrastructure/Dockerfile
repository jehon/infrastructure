
FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

COPY --from=root . /

COPY --from=publish . /setup

WORKDIR /app
ADD . /app

RUN --mount=type=cache,target=/var/cache/apt /app/setup.sh

# To avoid downloading from github
RUN rm -f /etc/apt/sources.list.d/jehon-github.sources
