#!/bin/bash

su - app
cd /home/app/lilsis
bundle exec rake ts:rebuild
