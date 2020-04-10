# Ubuntu LTS
FROM ubuntu:18.04

# Github Actions Runner and Docker Composer Version
ARG GH_RUNNER_VERSION="2.168.0"
ARG DOCKER_COMPOSE_VERSION="1.25.4"

# Php Version
ARG PHP_VERSION="7.3"

# Env variables
ENV RUNNER_NAME=""
ENV RUNNER_WORK_DIRECTORY="_work"
ENV RUNNER_TOKEN=""
ENV RUNNER_REPOSITORY_URL=""
ENV RUNNER_ALLOW_RUNASROOT=true
ENV GITHUB_ACCESS_TOKEN=""

# Disable scripts interactions
ENV DEBIAN_FRONTEND=noninteractive

# update system
RUN apt-get update -qy && apt-get install -y apt-utils; \
    apt-get upgrade -y;

# Install common dependencies
RUN apt-get install -y curl \
    tar \
    apt-transport-https \
    ca-certificates \
    sudo \
    unzip \
    lsb-release \
    supervisor \
    gnupg-agent \
    software-properties-common \
    build-essential \
    zlib1g-dev \
    gettext \
    liblttng-ust0 \
    libcurl4-openssl-dev \
    inetutils-ping \
    jq;


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

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chmod 644 /etc/supervisor/conf.d/supervisord.conf

# Install Docker CLI
RUN curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh

# Install Docker-Compose
RUN curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

RUN rm -rf /var/lib/apt/lists/* && \
    apt-get clean

RUN mkdir -p /home/runner
WORKDIR /home/runner
RUN GH_RUNNER_VERSION=${GH_RUNNER_VERSION:-$(curl --silent "https://api.github.com/repos/actions/runner/releases/latest" | grep tag_name | sed -E 's/.*"v([^"]+)".*/\1/')} \
    && curl -L -O https://github.com/actions/runner/releases/download/v${GH_RUNNER_VERSION}/actions-runner-linux-x64-${GH_RUNNER_VERSION}.tar.gz \
    && tar -zxf actions-runner-linux-x64-${GH_RUNNER_VERSION}.tar.gz \
    && rm -f actions-runner-linux-x64-${GH_RUNNER_VERSION}.tar.gz \
    && ./bin/installdependencies.sh \
    && chown -R root: /home/runner

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]