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

COPY --from=workspace . .

# To avoid security warning about untrusted folder from git
RUN git config --global --add safe.directory .

#
# With Setup inside
#
FROM basis AS basisWithSetup

ENV PATH="/workspace/tmp/python/common/bin:${PATH}"
ENV PYTHONPATH="/workspace/tmp/python/common:${PYTHONPATH}"

# Override the encrypted values in the hosts config
COPY --from=workspace tmp/infrastructure/50-hosts.yml infrastructure/inventory/50-hosts.yml

RUN ./setup.sh

RUN make infrastructure-dependencies
