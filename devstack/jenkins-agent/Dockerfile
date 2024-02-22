
FROM jenkins/inbound-agent

ENV DEBIAN_FRONTEND noninteractive 

USER root

RUN su root -c "apt update && apt --quiet --yes install shellcheck nodejs"

USER jenkins
