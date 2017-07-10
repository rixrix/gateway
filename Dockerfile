FROM ubuntu:16.04

LABEL maintainer="richard@mindginative.com"

ENV NVM_VERSION v0.33.2
ENV NODE_VERSION v7.7.2
ENV HOME=/home/root

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# add special user called `app`
RUN useradd --user-group --create-home --shell /bin/false -d /home/root app

# Install pre-reqs
RUN apt-get update && apt-get install -y \
    build-essential \
    checkinstall    \
    libusb-1.0-0-dev \
    libudev-dev \
    curl \
    git \
    vim

USER app

# Install NVM
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | bash

# Install NODE
RUN source ~/.nvm/nvm.sh; \
    nvm install $NODE_VERSION; \
    nvm use --delete-prefix $NODE_VERSION;

USER root
COPY package.json scripts/docker-start.sh $HOME/wot/
RUN chown -R app:app $HOME/*

USER app
WORKDIR $HOME/wot
RUN source ~/.nvm/nvm.sh; \
    nvm use --delete-prefix $NODE_VERSION; \
    npm install; \
    npm install pm2 --global;

USER root
COPY . $HOME/wot
RUN chown -R app:app $HOME/*;

USER app
RUN source ~/.nvm/nvm.sh; \
    nvm use --delete-prefix $NODE_VERSION;

CMD ["./scripts/docker-start.sh"]