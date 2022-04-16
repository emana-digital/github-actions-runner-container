# Ubuntu LTS
FROM ubuntu:20.04

# Github Actions Runner and Docker Composer Version
ARG GH_RUNNER_VERSION="2.290.1"
ARG DOCKER_COMPOSE_VERSION="1.29.2"

# Env variables
ENV RUNNER_NAME=""
ENV RUNNER_LABELS=""
ENV GITHUB_ACCESS_TOKEN=""
ENV RUNNER_WORK_DIRECTORY="_work"

ENV IS_ORG_RUNNER=""
ENV RUNNER_ORG_NAME=""

ENV RUNNER_REPOSITORY_URL=""

ENV RUNNER_ALLOW_RUNASROOT=true

# Disable scripts interactions
ENV DEBIAN_FRONTEND=noninteractive

# update system
RUN apt-get update -qy && apt-get install -y apt-utils; \
    apt-get upgrade -y;

# Install common dependencies
RUN apt-get install -y curl \
    tar \
    apt-transport-https \
    sshpass \   
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

# Install php 5.6 and extensions
RUN apt-get install -y \
    php5.6 \
    php5.6-bcmath \
    php5.6-bz2 \
    php5.6-intl \
    php5.6-gd \
    php5.6-mbstring \
    php5.6-mysql \
    php5.6-zip \
    php5.6-dom \
    php5.6-curl;

# Install php 7.3 and extensions
RUN apt-get install -y \
    php7.3 \
    php7.3-bcmath \
    php7.3-bz2 \
    php7.3-intl \
    php7.3-gd \
    php7.3-mbstring \
    php7.3-mysql \
    php7.3-zip \
    php7.3-dom \
    php7.3-curl;

# Install php 7.4 and extensions
RUN apt-get update; \
    apt-get install -y \
    php7.4 \
    php7.4-bcmath \
    php7.4-bz2 \
    php7.4-intl \
    php7.4-gd \
    php7.4-mbstring \
    php7.4-mysql \
    php7.4-zip \
    php7.4-dom \
    php7.4-curl;

# Install php 8.1 and extensions
RUN apt-get update; \
    apt-get install -y \
    php8.1 \
    php8.1-bcmath \
    php8.1-bz2 \
    php8.1-intl \
    php8.1-gd \
    php8.1-mbstring \
    php8.1-mysql \
    php8.1-zip \
    php8.1-dom \
    php8.1-curl;

# Allow composer to execute scripts as super user to remove warnings
ENV COMPOSER_ALLOW_SUPERUSER 1

# Register the COMPOSER_HOME environment variable
ENV COMPOSER_HOME /composer

# Get the composer installer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"

# Install composer globally
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Install node
RUN curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -; \
    apt-get install -y nodejs 

# Update npm, install yarn
RUN npm install -g npm;
RUN npm install -g yarn;

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