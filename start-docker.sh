#!/bin/bash

cd littlesis-apps/
docker run -d --name ls2.1 -p 9000:80 -p 9001:81 -v `pwd`:/var/www/littlesis littlesis:v0.0.6 tail -f /dev/null
