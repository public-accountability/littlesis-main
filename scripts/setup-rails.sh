#!/bin/bash

cd /var/www/littlesis/rails && bundle install
cd /var/www/littlesis/rails && bundle exec rake users:create_all_from_profiles


