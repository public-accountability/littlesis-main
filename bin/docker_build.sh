#!/bin/sh
set -eu

DOCKER_TAG=2.0.0

echo "Building littlesis/ruby:$DOCKER_TAG"
docker build -t littlesis/ruby:$DOCKER_TAG - < ./docker/ruby.dockerfile
docker tag littlesis/ruby:$DOCKER_TAG littlesis/ruby:latest

echo "Building littlesis/rails:$DOCKER_TAG"
docker build -t littlesis/rails:$DOCKER_TAG -f ./docker/rails.dockerfile ./rails
docker tag littlesis/rails:$DOCKER_TAG littlesis/rails:latest
