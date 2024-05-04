
ARG SOURCE

FROM ${SOURCE}

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app

COPY root/ /
COPY --from=publish . /setup

RUN apt --quiet update
