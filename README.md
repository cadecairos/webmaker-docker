# Webmaker Docker

This repo contains all anyone needs to run Webmaker services for local development in just a few commands.
It eliminates the need to fumble with installing, configuring, and running database services, and comes with sane defaults for everything.

## Prerequisites
All you need is [Docker and Docker Compose](http://docs.docker.com/). You'll find installation instructions for both programs (for Linux, Mac, and Windows) at that link.

That's right, no Node, NPM, Postgres, Redis, MySQL required here!

## Set up
This will be so easy, your mind is about to be blown. Note that the first run will take longer since docker will need to fetch container images from Docker Hub. Subsequent launches will be much faster.

1. Clone this repo: `git clone git@github.com:cadecairos/webmaker-docker`
2. Change directories into the data-services dir: `cd data-services`
3. Run the data services: `docker-compose up -d` (Remove `-d` flag to run in the foreground.)
4. Change directories into the services dir: `cd ../services`
5. Run Webmaker services: `docker-compose up -d`
6. Confirm all services are up by running `docker ps`.

## What just happened?
You're probably wondering what I just asked you to do. Let's take a look at what's going on here. You're probably wondering why I got you to run two docker-compose commands... Believe me, I really wanted to launch everything in one command, but as of writing this [it's not possible](https://github.com/docker/compose/pull/686), and the first `docker-compose` command launches containers that **must** be booted before the containers in the second `docker-compose` command.

When we ran `run-data-services.sh` in the data-services directory, we launched three containers using the following images: [cade/webmaker-postgres](https://hub.docker.com/r/cade/webmaker-postgres/), [mariadb:10](https://hub.docker.com/_/mariadb/), and [redis:3](https://hub.docker.com/_/redis/). The reason it is a bash file is to do some platform detection so that we can set the mount volume paths properly.

[cade/webmaker-postgres](https://hub.docker.com/r/cade/webmaker-postgres/) is an extension of the official [postgres:9.4](https://hub.docker.com/_/postgres/) image. It's customized to have some initialization SQL scripts added to the filesystem that inizialize the schemas and tables that [Webmaker API](https://github.com/mozilla/api.webmaker.org) and [Webmaker ID](https://github.com/mozilla/id.webmaker.org) use. You can find the Dockerfile in this repo, under [webmaker-postgres](/webmaker-postgres)

I instruct Docker to have the postgres and mariadb databases store data in a mounted folder (`data-services/mariadb_data` and `data-services/pg_data`), to make accessing it easier for tools on your host system (should you need/care for that). I also instruct Docker to use the "host" networking mode, essentiall binding the listening port of Postgres, Redis and MariaDB to your host machine ports. The TL;DR of this is that "localhost" on the containers is the same as "localhost" on your host computer.

The second `docker-compose up -d` we run in `/services` launches the Webmaker services. The images for these are: [Webmaker API](https://hub.docker.com/r/cade/webmaker-api/), [Webmaker ID](https://hub.docker.com/r/cade/webmaker-id/), and [legacy Webmaker LoginAPI](https://hub.docker.com/r/cade/legacy-webmaker-login/).

I've put the Dockerfiles for these in the [services-dockerfiles](/services-dockerfiles) folder of this repo. There's also a `.dockerignore` file there that's applicable to each project.

## What's running where, and what are my creds

If you're running Windows or OS X you'll need the IP of the Docker VM. To get this, run `docker-machine ip default`.

If you're running Linux then Docker is running on `localhost`.

* Postgres is listening on `DOCKER_IP:5432`
  * **username**: 'webmaker'
  * **password**: 'webmaker'
  * **database**: 'webmaker'
* MariaDB is listening on `DOCKER_IP:3306`
  * **username**: 'wmlogin'
  * **password**: 'wmlogin'
  * **database**: 'wmlogin'
  * **root password** :'root_wmlogin'
* Redis is listening on `DOCKER_IP:6379`
  * **There aren't any credentials to worry about**
* Webmaker API is listening on `DOCKER_IP:2015`
* Webmaker ID is listening on `DOCKER_IP:1234`
  * there's a client and secret already in the database for you
    * **client_id**: 'webmaker'
    * **secret**: 'webmaker'
    * **all grant types and response types allowed.**
    * **redirect_url** is 'example.com' - You can manually change it or insert a new one if you desire
* Legacy Login is listening on `DOCKER_IP`:3000
* Publish is listening on `DOCKER_IP`:2016
  * Projects get served from `DOCKER_IP`:8001
* Bramble is being served on `DOCKER_IP`:8000

The first time you run things, you'll need to create a user. easiest way is to visit `DOCKER_IP:1234/signup?DOCKER_IP:6767/signup?client_id=webmaker&state=state&response_type=code&scopes=user` and create an account.

## Shut down
To stop the containers, run `docker-compose stop` once in each of `services` and `data-services`.
