# Webmaker API

FROM ubuntu:14.04.2
MAINTAINER Mozilla Foundation <cade@mozillafoundation.org>

# install curl and native postgre bindings
RUN apt-get update && apt-get install -y \
  curl

# Install nodejs LTS PPA
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo bash -

# install nodejs v0.12.x
RUN apt-get update && apt-get install -y \
  nodejs

# create webmaker user
RUN useradd -d /webmaker webmaker

# set working directory
WORKDIR /webmaker

# Add webmaker-api source code and dependencies
COPY . ./

# Set Default env
RUN cp env.sample .env

# Expose default webmaker-api port
EXPOSE 2015

# fix permissions
RUN chown -R webmaker:webmaker .

# create webmaker user and directory
USER webmaker

# Command to execute when starting Webmaker API
CMD ["node","server"]
