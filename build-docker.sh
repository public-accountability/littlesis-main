#!/bin/bash

docker build --no-cache -t ls-rails:v0.0.9 -f passenger.docker .
docker build -t ls-php:v0.0.5 -f php.docker .
