#!/bin/bash

docker build --no-cache -t ls-rails:0.1.4 -f passenger.docker .
docker build -t ls-php:v0.0.5 -f php.docker .
