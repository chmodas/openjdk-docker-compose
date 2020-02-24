ARG JDK_VERSION

FROM azul/zulu-openjdk-alpine:$JDK_VERSION

# Env variables
ARG JDK_VERSION
ENV JDK_VERSION ${JDK_VERSION:-latest}

ARG DOCKER_VERSION
ARG DOCKER_COMPOSE_VERSION
ENV DOCKER_VERSION ${DOCKER_VERSION:-19.03.5}
ENV DOCKER_COMPOSE_VERSION ${DOCKER_COMPOSE_VERSION:-1.25.3}

# Install Docker
RUN set -eux; \
      wget -c https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz -O - | tar xfzv - --strip-components 1 --directory /usr/local/bin/; \
      dockerd --version; \
      docker --version

# Install Docker Compose
RUN apk --update add py-pip
RUN apk --update add --virtual build-dependencies gcc python2-dev libffi-dev openssl-dev musl-dev make; \
  pip install -U docker-compose==${DOCKER_COMPOSE_VERSION}; \
  apk del build-dependencies; \
  rm -rf `find / -regex '.*\.py[co]'`; \
  docker-compose --version

# Clean up
RUN set -eux; \
      rm -f /usr/local/openjdk-$JDK_VERSION/src.zip

