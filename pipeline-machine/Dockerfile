# Ubuntu LTS
FROM ubuntu:18.04
LABEL maintainer="alfredo@emana.digital"

# Github Actions Runner and Docker Composer Version
ARG GH_RUNNER_VERSION="2.168.0"
ARG DOCKER_COMPOSE_VERSION="1.25.4"

# PHP Version
ARG PHP_VERSION="7.3"

# Env variables
ENV RUNNER_NAME=""

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# update system
RUN apt-get update -qy && apt-get install -y apt-utils; \
    apt-get upgrade -y;

# Install common dependencies
RUN apt-get install -y software-properties-common apt-transport-https ca-certificates unzip curl sudo supervisor lsb-release;

# Install updated git and lftp
RUN apt-get purge git; \
    add-apt-repository ppa:git-core/ppa; \
    apt-get update; \
    apt-get install -y git lftp;

# Add php repo
RUN add-apt-repository ppa:ondrej/php;

# Install php and php extensions
RUN apt-get update; \
    apt-get install -y \
    php${PHP_VERSION} \
    php${PHP_VERSION}-bcmath \
    php${PHP_VERSION}-bz2 \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-curl;

# Allow composer to execute scripts as super user to remove warnings
ENV COMPOSER_ALLOW_SUPERUSER 1

# Register the COMPOSER_HOME environment variable
ENV COMPOSER_HOME /composer

# Get the composer installer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php

# Install composer globally
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Install prestissimo to speed up installations
RUN composer global require hirak/prestissimo

# Install laravel cli
RUN composer global require laravel/installer

# Install node
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -; \
    apt-get install -y nodejs 

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -; \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list; \
    apt-get update; \
    apt-get install yarn -y

# Install Docker CLI
RUN curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh

# Install Docker-Compose
RUN curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

WORKDIR /actions-runner
COPY install_actions.sh /actions-runner

RUN chmod +x /actions-runner/install_actions.sh \
  && /actions-runner/install_actions.sh ${GH_RUNNER_VERSION} \
  && rm /actions-runner/install_actions.sh

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]