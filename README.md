# littlesis-main

This repo contains instructions for running LittleSis in development and production. Docker used for development and Ansible is used to manage our production servers. The result is that we maintain two ways to install LittleSis and it's requirements. Using docker the quickest way to get started on LittleSis development.

The source code for LittleSis can be found here: [github.com/public-accountability/littlesis-rails](https://github.com/public-accountability/littlesis-rails)

## Requirements

* docker, docker-compose, mariadb client, bash, git
* A substantial amount of free disk space (> 20gb)

To install these requirements with debian use: `apt install bash git docker.io docker-compose mariadb-client`

## Helper program: ./littlesis

There's a helper bash program that will let you easily interact with the docker containers to do common tasks such as starting the rails console, running tests, starting sphinx, and viewing logs without having to remember esoteric docker & bash commands.

To see the script's features run: ```./littlesis help ```

Although not necessary, it is suggested to create a launcher script it. You can place it in ~/bin, /usr/local/bin or any suitable location on your path.

    ``` sh
    #!/bin/sh
    cd /path/to/this/repo || exit 1
    ./littlesis $@
    ```


## Installation Steps

1) Clone this repo. `git clone https://github.com/public-accountability/littlesis-main`.

2) Clone the rails repo: `littlesis setup-clone`

3) Build the docker images  `littlesis build`

4) Start the docker containers: `littlesis up`

5) Setup the database:  `littlesis setup-database`

6) Load a copy of the development database `littlesis run-sql /path/to/dev_db.sql`

7) Setup the testing database: `littlesis reset-test-db`

8) Compile test assets: `littlesis --test rake assets:precompile`

9) Run the tests: ` littlesis test `

The app is accessible at `localhost:8080` and `localhost:8081`. 8080 to directly to puma. 8081 is nginx.

## Subsequent runs

Start app: `littlesis up`

Start manticore: `littlesis rake ts:start`

Reconfigure and re-index manticore: `littlesis rake ts:rebuild`

Open rails console: `littlesis console`

The file _docker/config/nginx.conf_ contains the nginx configuration.

Login as system user:

* username: `user1@email.com`
* password: `password`


Create new user: `littlesis script create_example_user.rb`
