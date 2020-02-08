# Ubuntu LTS
FROM ubuntu:18.04

ARG GH_RUNNER_VERSION="2.164.0"
ARG DOCKER_COMPOSE_VERSION="1.24.1"

ENV RUNNER_NAME=""
ENV RUNNER_WORK_DIRECTORY="_work"
ENV RUNNER_TOKEN=""
ENV RUNNER_REPOSITORY_URL=""

# Disable scripts interactions
ENV DEBIAN_FRONTEND=noninteractive

# Add php repository
RUN apt-get update; \
    apt-get install -y apt-utils

# Install common dependencies and php repository
RUN apt-get -y install software-properties-common unzip curl git sudo supervisor apt-transport-https lsb-release ca-certificates; \
    add-apt-repository ppa:ondrej/php

###
## Start PHP config
###

# Install php and php extensions
RUN apt-get update; \
    apt-get install -y \
    php7.3 \
    php7.3-bcmath \
    php7.3-bz2 \
    php7.3-intl \
    php7.3-gd \
    php7.3-mbstring \
    php7.3-mysql \
    php7.3-zip \
    php7.3-fpm \
    php7.3-curl;

# Allow composer to execute scripts as super user to remove warnings
ENV COMPOSER_ALLOW_SUPERUSER 1

# Add composer from composer official image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install prestissimo to speed up installations
RUN composer global require hirak/prestissimo

# Install laravel cli
RUN composer global require laravel/installer

###
# End PHP Config
###

###
# Start Node and Yarn config
###

# Install node
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -; \
    apt-get install -y nodejs 

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -; \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list; \
    apt-get update; \
    apt-get install yarn

###
# End Node and Yarn config
###

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN chmod 644 /etc/supervisor/conf.d/supervisord.conf

# Install Docker CLI
RUN curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh

# Install Docker-Compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

###
# Clear cache (reduce container image)
###
RUN rm -rf /var/lib/apt/lists/*; \
    apt-get clean

RUN useradd -ms /bin/bash runner; \
    usermod -aG docker runner; \
    usermod -aG sudo runner; \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN curl -L -O https://github.com/actions/runner/releases/download/v${GH_RUNNER_VERSION}/actions-runner-linux-x64-${GH_RUNNER_VERSION}.tar.gz; \
    tar -zxf actions-runner-linux-x64-${GH_RUNNER_VERSION}.tar.gz; \
    rm -f actions-runner-linux-x64-${GH_RUNNER_VERSION}.tar.gz; \
    ./bin/installdependencies.sh; \
    chown -R runner: /home/runner

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

USER runner
