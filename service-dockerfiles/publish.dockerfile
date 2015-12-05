# Publish API

FROM ubuntu:14.04.2
MAINTAINER Mozilla Foundation <cade@mozillafoundation.org>

# install curl and native postgre bindings
RUN apt-get update && apt-get install -y \
  curl

# Install nodejs LTS PPA
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo bash -

# install nodejs LTS
RUN apt-get update && apt-get install -y \
  nodejs

# create webmaker user
RUN useradd -d /webmaker webmaker

# set working directory
WORKDIR /webmaker

# Add publish-api source code and dependencies
COPY . ./

# Set Default env
RUN cp env.dist .env

# expose Publish API port (default is 2015, OVERRIDE TO MATCH THIS)
# and expose noxmox port
EXPOSE 2016 8001

# for serving project data
RUN mkdir -p /tmp/mox/test

# fix permissions
RUN chown -R webmaker:webmaker . /tmp/mox

# install knex globally
RUN npm install -g knex \
  http-server

# create webmaker user and directory
USER webmaker

# Command to execute when starting Publish container
CMD  bash -c 'nohup http-server -p 8001 /tmp/mox/test > /dev/null 2>&1 &' && npm run migrate && npm start
