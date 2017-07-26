# littlesis-docker

LittleSis's code is divided across 3 repos:

Rails Code: https://github.com/public-accountability/littlesis-rails

Symfony Code: https://github.com/littlesis-org/littlesis

Oligrapher: https://github.com/skomputer/oligrapher

## Installation

When complete you should have a folder structure that looks like this:

```
/littlesis-docker/
	littlesis -> littlesis helper program
	ls_dev.conf -> nginx configuration
	config/ -> rails and symfony configurations
	mysql-data/ -> mysql server data
	chat/ -> rocket.chat configuration and mongo data
	apps/
		rails/ -> root of the rails repo
		symfony/ -> root of the symfony 

```

### Requirements:

* [Docker](https://www.docker.com/community-edition) and [docker-compose](https://docs.docker.com/compose/install/)

* mysql client. on debian get this via: ``` sudo apt install mysql-client ```

* A few common tools such as make, bash, and sed

* A substantial amount of free disk space (~ 10gb is safe)

### Helper program: ./littlesis

There's a helper bash program that will let you easily interact with the docker containers to do common tasks such as starting the rails console, running tests, starting sphinx, and viewing logs without having to remember esoteric docker & bash commands.

To see the script's features run: ``` ./littlesis help ```

### Overview

Steps for a fully functional LittleSis Development environment:

* Initial setup: download repos, configure files, pull docker images, launch the containers
* Load database
* Setup test database and rails tests
* Setup and start Sphinx
* Setup javascript tests


## Initial setup

1) Pull down the repos: ``` make apps ```

2) Pull down the containers: ``` make docker-pull ```

3) Edit the configuration files in ./config (optionally) and run ``` make config ```

4) Modify paths in docker-compose.yml if needed [otherwise skip this step]
   
5) run app: ``` littlesis up ``` or ``` littlesis up -d ```

## Setup the database

creates the databases littlesis and littlesis_test and creates the user 'littlesis'

``` bash
make db-setup
```

If you have an existing copy of LittleSis's database, populate the database now:

``` bash
mysql -u littlesis -pthemanbehindthemanbehindthethrone -h 127.0.0.1 littlesis < path/to/littlesis_db.sql
```

This can take anywhere from 30mins to 3 hours depending on the size of the database dump.

### Setup rails tests

Setup the testing database:

``` bash
littlesis rails cmd RAILS_ENV=test bundle exec rake db:structure:load
```

Run the tests:
``` bash
littlesis rails rspec
```

### Setup and start Sphinx

Both Rails and Symfony use their own version of Sphinx. The first time you create the containers (and anytime you rebuild a container) you'll have to re-index both versions of Sphinx. _Everytime_ you start the docker app, you will have to start sphinx. If you get a sphinx error page on a profile page, make sure that sphinx is started.

To start and index PHP's sphinx:

```
littlesis php sphinx index
littlesis php sphinx start

```

To start and index Rail's sphinx:

``` bash
littlesis rails rake ts:rebuild
```

### View Javascript tests:

Start Jasmine server:

``` bash
littlesis rails jasmine
```

and go to _localhost:8888_


### Docker images

The php dockerfile is php.docker and the Rails dockerfile is passenger.docker.

After updating the dockerfiles or after adding a new gem, change the version in the top of the Makfile and then build the docker images: ``` make build-rails-docker build-php-docker ``` and upload the new images to Docker Hub. See [here for dockerhub instructions](https://docs.docker.com/engine/getstarted/step_six/). 

### Nginx configuration

The file _ls_dev.conf_ contains the nginx configuration. 
The app is accessible at ``` localhost:8080 ``` and, additionally, if you add these two lines to  ``` /etc/hosts ``` :

```
127.0.0.1	ls.dev
127.0.0.1	lsapi.dev
```

you can access the site at ``` ls.dev:8080 ```

### Useful logs

*Nginx logs*
  - /var/log/nginx/access.log
  - /var/log/nginx/error.log

*Rails logs*:
   - /home/app/lilsis/log/development.log


