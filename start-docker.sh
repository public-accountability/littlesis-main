#!/bin/bash

cd littlesis-apps/
docker run -it -p 9000:80 -p 9001:81 -v `pwd`:/var/www/littlesis littlesis:v0.0.3
