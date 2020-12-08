#!/bin/sh
# Manticore is run on a UNIX socket set to /littlesis/tmp/development.sphinx
# in thinking_sphinx.yml when running in development. This is the correct path
# for the docker environment, but on a developer's machine this path
# is resolved to /path/to/littlesis-main/docker/tmp/development.sphinx
# This creates a symlink /littlesis/tmp/development.sphinx that points to the docker/tmp path
set -eu

sphinx_socket="$(realpath ./docker/tmp)/development.sphinx"

if ! test -e /littlesis/tmp/development.sphinx
then
    sudo mkdir -p /littlesis/tmp
    sudo ln -s "$sphinx_socket" /littlesis/tmp/development.sphinx
    sudo chown "$USER:$USER" /littlesis/tmp/development.sphinx
fi
