#!/bin/bash
# an awful hack that fixes a issue involving rotating ips for the mysql docker container
# and the inability for symfony to use a string as a host. 
# There's probably an easier fix that I don't know about.

mysql_ip=$(docker exec littlesisdocker_php_1 /bin/bash -c 'cat /etc/hosts' | grep 'mysql' | head -n 1 | awk '{print $1}')

sed -i -r "s/(.+thethrone@)(.+)\/littlesis/\1${mysql_ip}\/littlesis/g" ./config/symfony/databases.yml

bash ./config.sh

docker exec littlesisdocker_php_1 /bin/bash -c 'php /var/www/littlesis/symfony/symfony cc'
