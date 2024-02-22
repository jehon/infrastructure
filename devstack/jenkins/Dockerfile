#
# https://github.com/jenkinsci/docker/blob/master/README.md
#
# !! /var/jenkins_home will be mounted as volume
#    nothing can be stored there from here
#

FROM jenkins/jenkins:lts

ENV PATH="/jenkins-bin:${PATH:-}"
ENV PLUGINS_FORCE_UPGRADE=true
ENV JENKINS_URL=http://localhost:8080/jenkins
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false ${JAVA_OPTS:-}"
ENV TZ=Europe/Brussels
ENV JENKINS_GUEST_HOME="$JENKINS_HOME"
ENV JENKINS_EXPORT=/mnt/docker/jenkins
ENV JENKINS_LOCAL_URL="http://localhost:8080/jenkins"

# See https://github.com/jenkinsci/docker/blob/master/README.md#installing-more-tools
ENV JENKINS_REF=/usr/share/jenkins/ref

 # Web access
EXPOSE 8080
EXPOSE 50000

WORKDIR $JENKINS_HOME

#####################################################
# Root section
#####################################################
USER root

RUN apt-get update && apt-get install -y rsync curl docker.io

#####################################################
# Back to jenkins user
#####################################################
USER jenkins

# Add generated
ADD --chown=jenkins built/ ${JENKINS_REF}/

# Add config
ADD --chown=jenkins config/raw/ ${JENKINS_REF}/

# Install plugins
ADD config/plugins.txt /plugins.txt
RUN jenkins-plugin-cli --plugin-file /plugins.txt
