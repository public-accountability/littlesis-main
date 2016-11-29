#!/bin/bash

su - app -c "cd /home/app/lilsis && bundle exec rake ts:rebuild"
