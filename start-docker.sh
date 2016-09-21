#!/bin/bash

cd littlesis-apps/
# docker run -d --name ls2.1 -p 9000:80 -p 9001:81 -v `pwd`:/var/www/littlesis littlesis:v0.0.6 tail -f /dev/null
docker run -d --name ls3 -p 9100:80 -p 9101:81 -v `pwd`:/var/www/littlesis littlesis:v0.1.0 tail -f /dev/null
