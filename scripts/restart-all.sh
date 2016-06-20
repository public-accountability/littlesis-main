#!/bin/bash

cd /var/www/littlesis/rails && bin/delayed_job restart
cd /var/www/littlesis/rails && bundle exec rake ts:restart
service apache2 restart
service mysql restart
service memcached restart
searchd --config /var/www/littlesis/symfony/config/sphinx.conf

