# Webmaker ID

FROM ubuntu:14.04.2
MAINTAINER Mozilla Foundation <cade@mozillafoundation.org>

# install curl and native postgre bindings
RUN apt-get update && apt-get install -y \
  curl

# Install nodejs 0.12.x PPA
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo bash -

# install nodejs v0.12.x
RUN apt-get update && apt-get install -y \
  nodejs

# create webmaker user
RUN useradd -d /webmaker webmaker

# set working directory
WORKDIR /webmaker

# Add webmaker ID source code and dependencies
COPY . ./

# Set Default env
RUN cp sample.env .env

# Expose default ID port
EXPOSE 1234

# fix permissions
RUN chown -R webmaker:webmaker .

# use webmaker user
USER webmaker

# Command to execute when starting Webmaker ID
CMD ["npm", "run", "server"]
