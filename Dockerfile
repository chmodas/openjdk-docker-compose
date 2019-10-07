FROM openjdk:11.0.4-jdk-slim-buster

# Env variables
ARG DOCKER_VERSION
ENV DOCKER_VERSION ${DOCKER_VERSION:-19.03.1}
ARG DOCKER_COMPOSE_VERSION
ENV DOCKER_COMPOSE_VERSION ${DOCKER_COMPOSE_VERSION:-1.24.1}

# Install build stuff
RUN set -eux; \
      apt-get update; \
      apt-get install -y --no-install-recommends apt-transport-https ca-certificates curl gnupg2 software-properties-common

# Install Docker
RUN set -eux; \
      curl -L https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz | tar xfzv - --strip-components 1 --directory /usr/local/bin/; \
      dockerd --version; \
      docker --version

# Install Docker Compose
RUN set -eux; \
      curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose; \
      chmod +x /usr/bin/docker-compose; \
      docker-compose --version

# Clean up
RUN set -eux; \
      apt-get clean; \
      rm -f /usr/local/openjdk-11/src.zip

