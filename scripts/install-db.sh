#!/bin/bash

service mysql restart
mysql -u root -proot -e "create database littlesis;"
mysql -u root -proot -e "grant all privileges on littlesis.* to 'littlesis'@'localhost' identified by 'themanbehindthemanbehindthethrone';"

mysql -u littlesis -pthemanbehindthemanbehindthethrone littlesis < /data/littlesis_db.sql
