#!/bin/bash

docker build --no-cache -t ls-rails:v0.0.5 -f passenger.docker .
docker build --no-cache -t ls-php:v0.0.5 -f php.docker .
