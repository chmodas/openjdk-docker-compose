ARG JDK_VERSION

FROM openjdk:$JDK_VERSION-jdk-slim-buster

# Env variables
ARG JDK_VERSION
ENV JDK_VERSION ${JDK_VERSION:-latest}

ARG DOCKER_VERSION
ARG DOCKER_COMPOSE_VERSION
ENV DOCKER_VERSION ${DOCKER_VERSION:-20.10.5}
ENV DOCKER_COMPOSE_VERSION ${DOCKER_COMPOSE_VERSION:-1.28.6}

# Install build stuff
RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends curl

# Install Docker
RUN set -eux; \
  curl -L https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz | tar xfzv - --strip-components 1 --directory /usr/local/bin/; \
  dockerd --version; \
  docker --version

# Install Docker Compose
RUN set -eux; \
  curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose; \
  chmod 755 /usr/bin/docker-compose; \
  docker-compose --version

# Install GnuPG (for signing Maven Central artifacts)
RUN set -eux; \
  apt-get install -y --no-install-recommends gnupg

# Clean up
RUN set -eux; \
  apt-get clean; \
  rm -f /usr/local/openjdk-$JDK_VERSION/src.zip

