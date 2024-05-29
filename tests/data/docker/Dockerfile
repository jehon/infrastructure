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

ENV PATH="/workspace/tmp/python/common/bin:${PATH}"
ENV PYTHONPATH="/workspace/tmp/python/common:${PYTHONPATH}"

RUN /workspace/setup.sh

RUN make dependencies
