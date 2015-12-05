# Webmaker API

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

# Add webmaker-api source code and dependencies
COPY . ./

# Set Default env
RUN cp env.dist .env

# expose Publish API port (default is 2015, OVERRIDE TO MATCH THIS)
# and expose noxmox port
EXPOSE 2016 8001

# fix permissions
RUN chown -R webmaker:webmaker .

# install knex globally
RUN npm install -g knex \
  http-server

# create webmaker user and directory
USER webmaker

# Command to execute when starting Webmaker API
CMD  http-server -p 8001 -s & && npm run migrate && npm start
