# littlesis-main

This repo contains instructions for running LittleSis in development with docker and an ansible playbook for running LittleSis in production.

The source code for LittleSis's can be found here: [github.com/public-accountability/littlesis-rails](https://github.com/public-accountability/littlesis-rails)

## Installation

When complete you should have a folder structure that looks like this:

```
/littlesis-main/
	littlesis -> littlesis helper program
	ls_dev.conf -> nginx configuration
	config/ -> rails configuration
	mysql-data/ -> mysql server data
	rails/ -> root of the rails repo
	ansible -> ansible playbook. ignore this unless running littlesis on prod

```

### Requirements:

* [Docker](https://www.docker.com/community-edition) and [docker-compose](https://docs.docker.com/compose/install/). See the [Debian installation guide](https://docs.docker.com/install/linux/docker-ce/debian/).

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

1) Clone this repo. `git clone https://github.com/public-accountability/littlesis-main`.

The rest of these commands assumes that your working directory is the root of this repository.

2) Pull down the rails repo and configure it: ``` make setup```

3) Pull down the containers: ``` make docker-pull ```

4) [optional] Edit the configuration files in ./config

5) Run ` make config `

6) run app: ` ./littlesis up `

7) Setup the database:  ` make db-setup `

8) Load a copy of the development database

```
mysql -u littlesis -pthemanbehindthemanbehindthethrone -h 127.0.0.1 littlesis < /path/to/dev_db.sql
```

### Setup rails tests

Setup the testing database: ` littlesis reset-test-db `
Compile test assets: `littlesis rake-test assets:precompile `
Run the tests: ` littlesis test `

### Setup and start Sphinx

The first time you create the containers (and anytime you rebuild a container) you'll have to re-index Sphinx. _Everytime_ you start the docker app, you will have to start sphinx. If you get a sphinx error page on a profile page, make sure that sphinx is started.

To start and index sphinx: ` littlesis rake ts:rebuild `

### Docker images

The dockerfile is named 'littlesis.docker'

After updating the dockerfile or after adding a new gem:

1) change the docker image version number in the top in the Makefile and docker-compose.yml

2) if you just have minor changes, such as adding a gem, you can just commit your changes to the docker container (`docker ps` to get the container ID, then: `docker commit <ID> <image>`)

3) or, for larger-scale changes to the container itself you can rebuild the docker images: ` make build-rails-docker `

4) upload the new images to Docker Hub. See [here for dockerhub instructions](https://docs.docker.com/engine/getstarted/step_six/).

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
