# login.webmaker.org

FROM ubuntu:14.04.2
MAINTAINER Mozilla Foundation <cade@mozillafoundation.org>

# install curl and native postgre bindings
RUN apt-get update && apt-get install -y \
  curl

# Install nodejs LTS PPA
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo bash -

# install nodejs LTS
RUN apt-get update && apt-get install -y \
  g++ \
  make \
  nodejs \
  python

# create webmaker user and directory
RUN useradd -d /webmaker webmaker

# set working directory
WORKDIR /webmaker

# Add login source code and dependencies
COPY . ./

# Set Default env
RUN cp env.sample .env

# Expose default login port
EXPOSE 3000

# fixing bcrypt
RUN npm uninstall bcrypt && npm install bcrypt

# fix permissions
RUN chown -R webmaker:webmaker .

USER webmaker

# Command to execute when starting Webmaker API
CMD ["node","app"]
