# littlesis-main

Welcome to the LittleSis project! LittleSis has been tracking powerful people and organizations since 2009. The repo [littlesis-main](https://github.com/public-accountability/littlesis-main) contains instructions for setting up a development environment for LittleSis.org.

Our code can be found under the github organization [public-accountability](https://github.com/public-accountability). [littlesis-rails](https://github.com/public-accountability/littlesis-rails) is the central rails repository for the project. [oligrapher](https://github.com/public-accountability/oligrapher) is our javascript/react mapping tool. [littlesis-browser-addon](https://github.com/public-accountability/littlesis-browser-addon) is a chrome browser extension to add relationships to the database. [pai-core-functionality](https://github.com/public-accountability/pai-core-functionality), [pai-packages](https://github.com/public-accountability/pai-packages), [pai](https://github.com/public-accountability/pai), [littlesis-packages](https://github.com/public-accountability/littlesis-packages), [littlesis-news-theme](https://github.com/public-accountability/littlesis-news-theme), and [littlesis-core-functionality](https://github.com/public-accountability/littlesis-core-functionality) are the themes and functionality for our two wordpress sites: [news.littlesis.org](https://news.littlesis.org) and [public-accountability.org](https://public-accountability.org/).

Our code is all open source, licensed with the General Public License version 3.0.

## Project History

Matthew Skomarovsky co-founded LittleSis and was the initial developer behind the project. When it started in 2009, LittleSis was a PHP [see here](https://github.com/littlesis-org/littlesis) for the original PHP application). The port to Ruby on Rails began in 2013 and finished in 2017.

Ziggy ([@aepyornis](https://github.com/aepyornis)) joined in 2016 and currently maintains the project.

Along the way, Austin ([@aguestuser](https://github.com/aguestuser)) and on oligrapher and the rails codebase. Liz ([@lizstarin](https://github.com/lizstarin)) helped port PHP code to rails and
developed the chrome extension. Pea ([@misfist](https://github.com/misfist)) coded our wordpress sites. Since 2020, Rob [@robjlucas](https://github.com/robjlucas) has contributed to the rails application.

LittleSis is a project of [The Public Accountability Initiative](https://public-accountability.org/), a non-profit public interest research organization focused on corporate and government accountability.

## Software Overview

Application: Ruby on Rails
Database: MariaDB
Web Server: Puma, Nginx
Search: Manticore
Cache: Redis
Blog: Wordpress
OS: Debian

Development requirements:

* docker, docker-compose, mariadb client, bash, git
* A substantial amount of free disk space (> 20gb)

To install these requirements with debian use: `apt install bash git docker.io docker-compose mariadb-client`

## Helper program: ./littlesis

There's a helper bash program that will let you easily interact with the docker containers to do common tasks such as starting the rails console, running tests, starting sphinx, and viewing logs without having to remember esoteric docker & bash commands.

To see the script's features run: ```./littlesis help ```

Although not necessary, it is suggested to create symlink for `littlesis`: `sudo ln -s ./littlesis /usr/local/bin/littlesis`

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

The app is accessible at `localhost:8080` and `localhost:8081`. 8080 goes to directly to puma. 8081 is nginx.

The configurations for nginx and mariadb are in the  folder _docker/config_.

## Subsequent runs

Start app: `littlesis up`

Open rails console: `littlesis console`

*Manticore*
    - status: `littlesis rake ts:status`
    - start: `littlesis rake ts:start`
    - index: `littlesis rake ts:index`
    - reconfigure: `littlesis rake ts:rebuild`

Clear logs:  `littlesis rake log:clear`

Clear cache: `littlesis runner Rails.cache.clear`

Start DelayedJob: `littlesis delayed_job start`

Login as system user:

* username: `user1@email.com`
* password: `password`


Create new user: `littlesis script create_example_user.rb`

Reset user password:  `User.find_by(email: <EMAIL>).send_reset_password_instructions`

Update Network Map Collections: `littlesis rake maps:update_all_entity_map_collections`
