#!/bin/bash

docker build -t ls-rails:v0.0.2 -f passenger.docker .
docker build -t ls-php:v0.0.3 -f php.docker .
