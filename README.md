# littlesis-main

This repo contains instructions and configurations for running littlesis in development mode with docker and an ansible playbook for running littlesis in production on an ubuntu server.

Littlesis's code can be found here: 

https://github.com/public-accountability/littlesis-rails

Our javascript interactive mapping tool, Oligrapher:

https://github.com/skomputer/oligrapher

## Installation

When complete you should have a folder structure that looks like this:

```
/littlesis-main/
	littlesis -> littlesis helper program
	ls_dev.conf -> nginx configuration
	config/ -> rails configuration
	mysql-data/ -> mysql server data
	chat/ -> rocket.chat configuration and mongo data
    rails/ -> root of the rails repo
	ansible -> ansible playbook. ignore this unless running littlesis on prod

```

### Requirements:

* [Docker](https://www.docker.com/community-edition) and [docker-compose](https://docs.docker.com/compose/install/)

* mysql/mariadb client. on debian get this via: ` sudo apt install mariadb-client `

* A few common tools such as make, bash, and sed

* A substantial amount of free disk space (> 20gb)

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

1) Pull down the rails repo and configure it: ``` make setup```

2) Pull down the containers: ``` make docker-pull ```

3) [optional] Edit the configuration files in ./config and run: ``` make config ```

4) run app: ` ./littlesis up ` or ` ./littlesis up -d `

4) Setup the database:  ` make db-setup `

## Load the development database

If you have an existing copy of LittleSis's database, populate the database now:

``` bash
mysql -u littlesis -pthemanbehindthemanbehindthethrone -h 127.0.0.1 littlesis < path/to/littlesis_db.sql
```

This can take anywhere from 30mins to 3 hours depending on the size of the database dump.

### Setup rails tests

Setup the testing database:

``` bash
littlesis reset-test-db
```

Run the tests: ` littlesis rspec `

### Setup and start Sphinx

The first time you create the containers (and anytime you rebuild a container) you'll have to re-index Sphinx. _Everytime_ you start the docker app, you will have to start sphinx. If you get a sphinx error page on a profile page, make sure that sphinx is started.

To start and index Rail's sphinx:

``` bash
littlesis rake ts:rebuild
```

### View Javascript tests:

Start Jasmine server:

``` bash
littlesis jasmine
```

and go to _localhost:8888_


### Docker images

The dockerfile is named 'littlesis.docker'

After updating the dockerfiles or after adding a new gem, change the version in the top of the Makfile and then build the docker images: ``` make build-rails-docker build-php-docker ``` and upload the new images to Docker Hub. See [here for dockerhub instructions](https://docs.docker.com/engine/getstarted/step_six/).

### Nginx configuration

The file _ls_dev.conf_ contains the nginx configuration.
The app is accessible at ``` localhost:8080 ``` and, additionally, if you add this lines to  ``` /etc/hosts ``` :

```
127.0.0.1	littlesis.local
```

you can access the site at ``` littlesis.local:8080 ```

### Useful logs

*Nginx logs*
  - /var/log/nginx/access.log
  - /var/log/nginx/error.log

*Rails logs*:
   - /home/app/lilsis/log/development.log
   - /home/app/lilsis/log/test.log

## Subsequent Runs

1. Start the app:

```
cd /path/to/littlesis-main
./littlesis up -d
./littlesis rake ts:start
```

2. Point your favorite browser to `localhost:8008`

3. If desired, login with:

* username: `user1@email.com`
* password: `password`

### Bonus Tips! 

#### Running rspec/rubocop outside of docker

It's possible to run rspec *outside* of the docker if you install ruby, bundler and all the development gems on your computer.

add this line to /etc/hosts to allow rspec to discover the docker database:

```
127.0.0.1	mysql
```

#### use the helper program from anywhere

Add this function to your bash configuration:

``` bash
littlesis() {
    local PWD=$(pwd)
    cd /path/to/this/repo
    ./littlesis "$@"
    cd $PWD
}
```

or this fish function if you use 🐟:

``` fish
function littlesis
	pushd (pwd)
	cd /path/to/this/repo
	./littlesis $argv
	popd
end
```

#### Don't run rocket.chat

If you are not working on the chat integration you find might it useful to comment
out the lines in docker-compose.yml so they don't run.

comment out all lines below the ` rocketchat: ` service and comment out the two lines in the depends_on section of web: 

``` yml
- mongo
- rocketchat
```
