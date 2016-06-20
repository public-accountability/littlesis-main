#!/bin/bash

service mysql restart

echo "create database littlesis; grant all privileges on littlesis.* to 'littlesis'@'localhost' identified by 'themanbehindthemanbehindthethrone';" | mysql -u root -proot

mysql -u littlesis -pthemanbehindthemanbehindthethrone littlesis < /data/littlesis_db.sql
