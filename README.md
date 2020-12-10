# littlesis-main

This repo contains instructions for running LittleSis in development and production. Docker is primarily used while developing, and Ansible is used to manage our production servers. The result is that we maintain two ways to install LittleSis and it's requirements.

The source code for LittleSis can be found here: [github.com/public-accountability/littlesis-rails](https://github.com/public-accountability/littlesis-rails)

## Requirements

* [Docker](https://www.docker.com/community-edition) and [docker-compose](https://docs.docker.com/compose/install/). See the [Debian installation guide](https://docs.docker.com/install/linux/docker-ce/debian/).

* mysql/mariadb client. on debian get this via: ` sudo apt install mariadb-client `

* A few common tools such as bash and git

* A substantial amount of free disk space (> 20gb)

## Helper program: ./littlesis

There's a helper bash program that will let you easily interact with the docker containers to do common tasks such as starting the rails console, running tests, starting sphinx, and viewing logs without having to remember esoteric docker & bash commands.

To see the script's features run: ``` ./littlesis help ```

## Overview

Steps for a fully functional LittleSis Development environment:

* Initial setup: download repos, configure files, pull docker images, launch the containers
* Load database
* Setup test database and rails tests
* Setup and start Sphinx
* Setup javascript tests


## Installation

1) Clone this repo. `git clone https://github.com/public-accountability/littlesis-main`.

The rest of these commands assumes that your working directory is the root of this repository.

2) Clone the rails repo ` bin/clone.sh `

3) Build the docker images  ` bin/docker_build.sh `

4) run app: ` ./littlesis up `

5) Setup the database:  `  bin/mysql_setup.sh `

6) Load a copy of the development database `bin/load_database.sh /path/to/dev_db.sql`

### Setup rails tests

Setup the testing database: ` littlesis reset-test-db `
Compile test assets: `littlesis rake-test assets:precompile `
Run the tests: ` littlesis test `

### Setup and start Sphinx

The first time you create the containers (and anytime you rebuild a container) you'll have to re-index Sphinx. _Everytime_ you start the docker app, you will have to start sphinx. If you get a sphinx error page on a profile page, make sure that sphinx is started.

To start and index sphinx: ` littlesis rake ts:rebuild `

### Nginx configuration

The file _docker/config/nginx.conf_ contains the nginx configuration.
The app is accessible at ``` localhost:8080 ``` and, additionally, if you add this lines to  ``` /etc/hosts ``` :

```
127.0.0.1	littlesis.local
```

you can access the site at ``` littlesis.local:8080 ```

### Monitor logs


- `littlesis rails-logs`
- `littlesis rails-test-logs`
- `littlesis nginx access`

## Subsequent Runs

1. Start the app:

```
cd /path/to/littlesis-main
./littlesis up
./littlesis rake ts:start
```

2. Point your favorite browser to `localhost:8080`

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

#### Use the helper program from anywhere

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

or name this script "littlesis" and put it somewhere on your path:

```
#!/bin/sh
cd /path/to/this/repo || exit 1
./littlesis $@
```
```
