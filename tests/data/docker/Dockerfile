
ARG SOURCE

FROM ${SOURCE}

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /workspace

COPY root/ /
COPY --from=publish . /setup

RUN apt --quiet update

RUN apt install --yes git

# To avoid security warning about untrusted folder from git
RUN git config --global --add safe.directory /workspace
