#!/bin/bash

docker build -t ls-rails:v0.0.3 -f passenger.docker .
docker build -t ls-php:v0.0.5 -f php.docker .
