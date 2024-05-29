#
# Without Setup
#

FROM ubuntu:latest AS basis

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /workspace

COPY root/ /
COPY --from=publish . /setup

RUN apt --quiet update

RUN apt install --yes git

COPY --from=workspace . /workspace

# To avoid security warning about untrusted folder from git
RUN git config --global --add safe.directory /workspace

#
# With Setup inside
#
FROM basis AS basisWithSetup

RUN --mount=type=cache,target=/var/cache/apt /workspace/setup.sh
