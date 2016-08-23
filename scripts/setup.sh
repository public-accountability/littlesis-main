#!/bin/bash

# install gems
cd /var/www/littlesis/rails && bundle install

# create sphnix indexes -- php
indexer --config /var/www/littlesis/symfony/config/sphinx.conf entities entities_delta lists lists_delta notes notes_delta
    
# create sphnix indexes -- rails
cd /var/www/littlesis/rails && bundle exec rake ts:clear
cd /var/www/littlesis/rails && bundle exec rake ts:configure
cd /var/www/littlesis/rails && bundle exec rake ts:rebuild
cd /var/www/littlesis/rails && bundle exec rake ts:restart

