#!/bin/sh

if ! mountpoint -q ~/littlesis
then
    sshfs littlesis-dev:/littlesis ~/littlesis
fi

ssh -4 -T -L 8080:localhost:8080 -L 8888:localhost:8888 -L 3306:localhost:3306 littlesis-dev
