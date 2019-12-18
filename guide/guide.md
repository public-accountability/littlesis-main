# LittleSis Development Guide

Welcome to the LittleSis project! LittleSis has been tracking powerful people and organizations since 2009. This guide will help you understand the LittleSis data model, how the code is structured, and how we host our site.

## Our Software

All our code can be found under the github organization [public-accountability](https://github.com/public-accountability).

While the core of LittleSis.org is rails, we have some related components that use other technologies.

The repo [littlesis-main](https://github.com/public-accountability/littlesis-main) contains instructions for getting the development environment setup (via docker), an ansible playbook for running LittleSis in production, and this guide.

[littlesis-rails](https://github.com/public-accountability/littlesis-rails) is the central rails repository for the project.
[oligrapher](https://github.com/public-accountability/oligrapher) is our javascript/react mapping tool.
[littlesis-browser-addon](https://github.com/public-accountability/littlesis-browser-addon) is a chrome browser extension to add relationships to the database.
[pai-core-functionality](https://github.com/public-accountability/pai-core-functionality), [pai-packages](https://github.com/public-accountability/pai-packages), [pai](https://github.com/public-accountability/pai), [littlesis-packages](https://github.com/public-accountability/littlesis-packages), [littlesis-news-theme](https://github.com/public-accountability/littlesis-news-theme), and [littlesis-core-functionality](https://github.com/public-accountability/littlesis-core-functionality) are the themes and functionality for our two wordpress sites: [news.littlesis.org](https://news.littlesis.org) and [public-accountability.org](https://public-accountability.org/).

Our code is all open source, licensed with the General Public License version 3.0.

## People

Matthew Skomarovsky co-founded LittleSis and was the initial developer behind the project. When it started in 2009, LittleSis was a PHP app (see [here](https://github.com/littlesis-org/littlesis) for the legacy PHP code). The port to Ruby on Rails began in 2013 and finished in 2017.

Along the way, Austin ([@aguestuser](https://github.com/aguestuser)) worked on oligrapher and the rails codebase. Liz ([@lizstarin](https://github.com/lizstarin)) helped port PHP code to rails and developed the chrome extension. Pea ([@misfist](https://github.com/misfist)) coded our wordpress sites.

The project is currently maintained by ziggy ([@aepyornis](https://github.com/aepyornis)).

LittleSis is a project of [The Public Accountability Initiative](https://public-accountability.org/), nonprofit public interest research organization focused on corporate and government accountability.

## Technical Overview

See [ansible/README.md](../ansible/README.md) for instructions on how to operate LittleSis's production servers.

## Software we use
### Debian
### Ruby and Rails
### MariaDB
### Javascript: React, jQuery, webpack
### Nginx + Puma
### Redis
### Manticore (fork of Sphinx)
### PHP and wordpress
