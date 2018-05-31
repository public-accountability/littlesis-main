# LittleSis Code and Development Guide

Welcome to the LittleSis project! LittleSis has been tracking powerful people and organizations since 2009. This guide will help you understand the LittleSis data model, how the code is structured, and how we host our site.


## Code and components

All our code can be found under the github organization [public-accountability](https://github.com/public-accountability). 

While the core of LittleSis.org is rails, we have some related components that use other technologies.

The repo [littlesis-main](https://github.com/public-accountability/littlesis-main) contains instructions for getting the development environment setup (via docker), an ansible playbook for running LittleSis in production, and this guide. 

[littlesis-rails](https://github.com/public-accountability/littlesis-rails) is the central rails repository for the project.

[oligrapher](https://github.com/public-accountability/oligrapher) is our javascript/react mapping tool. 

[littlesis-browser-addon](https://github.com/public-accountability/littlesis-browser-addon) is a chrome browser extension to add relationships to the database.

[pai-core-functionality](https://github.com/public-accountability/pai-core-functionality), [pai-packages](https://github.com/public-accountability/pai-packages), [pai](https://github.com/public-accountability/pai), [littlesis-packages](https://github.com/public-accountability/littlesis-packages), [littlesis-news-theme](https://github.com/public-accountability/littlesis-news-theme), and [littlesis-core-functionality](https://github.com/public-accountability/littlesis-core-functionality) are the themes and functionality for our two wordpress sites: [news.littlesis.com](https://news.littlesis.com) and [public-accountability.org](https://public-accountability.org/).


Our code is all open source, licensed with the General Public License version 3.0.


### Who made this?

Matthew Skomarovsky co-founded LittleSis and was the initial developer behind the project. When it started in 2009, LittleSis was a PHP app (see [here](https://github.com/littlesis-org/littlesis) for the legacy PHP code). The port to Ruby on Rails began in 2013 and finished in 2017.

Along the way, Austin ([@aguestuser](https://github.com/aguestuser)) worked on oligrapher and the rails codebase. Liz ([@lizstarin](https://github.com/lizstarin)) helped port PHP code to rails and developed the chrome extension. Pea ([@misfist](https://github.com/misfist)) coded our wordpress sites.

The project is currently maintained by ziggy ([@aepyornis](https://github.com/aepyornis)).


## Core development principles

## Data Model

## Rails Code base

## Production and operations

LittleSis runs on ubuntu servers. We have 3 core servers:

1) Rails Server: Our "main" web server which runs our rails app + wordpress site
2) Chat Server: a server running Rocket.Chat with docker
3) Database server running MariaDb

Our traffic is proxied by Cloudflare. Cloudlfare is also used to manage our DNS. Our assets are hosted on Amazon S3 and served via Amazon's cloudfront.

### Rails Server

#### Creating a new server.

In the advent that you need to create an entirely new server, there is an ansible playbook to setup up a new ubuntu xenial server. See the `ansible` folder for the playbook. Variables are configured in `ansible/group_vars/all`. The wordpress will need some additional setup (described later).

The ansible playbook looks for a file of secrets located at ` ~/littlesis.yml `. This file ~can~ should be encrypted with [ansible vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html). `~/littlesis.yml` contains all sensitive information and credentials including database passwords and tls certificates. 

#### Rails Server Components

##### Nginx/Phusion Passenger

Our core webserver is [Nginx/Phusion Passenger](https://www.phusionpassenger.com), which allows us to run our ruby app using nginx.

##### RVM

Rather than relying on ubuntu for ruby, we use RVM (managed via ansible) to install ruby. Whenever we update our ruby version in the ansible variables section, re-run the playbook with the ruby tag and it will update ruby for us

``` sh
ansible-playbooks site.yml --tags 'ruby'
```

##### Redis

For caching, our rails app uses Redis.  In `ansible/group_vars/all` a few redis configuration variables have been set, but generally redis is remarkable stable. It's never crashed, require no maintaince, and even saves the cache to disk periodically and automatically restores it upon restart.

##### Sphinx

Sphinx is used by rails for full-text searching of documents. The running of sphinx is managed via rake tasks.

##### PHP/wordpress

news.littlesis.org is also run on our main rails server. The wordpress files are located here: ``` /var/www/news ```
