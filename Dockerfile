FROM openjdk:8u151-jdk-alpine3.7

RUN apk update
RUN apk add \
    gnupg \
    tar \
    ruby \
    git \
    zip \
    curl \
    wget \
    && rm -rf /var/cache/apk/*
	
ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT 50000

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid
RUN addgroup -g ${gid} ${group} \
    && adduser  -h "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

# Jenkins home directory is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME /var/jenkins_home

# `/usr/share/jenkins/ref/` contains all reference configuration we want
# to set on a fresh new installation. Use it to bundle additional plugins
# or config file with your custom jenkins Docker image.
RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d

COPY resources/tini /bin/tini
RUN chmod +x /bin/tini

COPY resources/init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy

ARG JENKINS_VERSION
ENV JENKINS_VERSION ${JENKINS_VERSION:-2.50}
ARG JENKINS_SHA
ENV JENKINS_SHA ${JENKINS_SHA:-e97670636394092af40cc626f8e07b092105c07b}
