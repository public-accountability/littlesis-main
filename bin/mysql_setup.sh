#!/bin/sh
set -e


mysql -h 127.0.0.1 -u root -proot <<SQL
create database littlesis;
grant all privileges on littlesis.* to 'root'@'%' identified by 'root';
grant all privileges on littlesis.* to 'littlesis'@'%' identified by 'themanbehindthemanbehindthethrone' with grant option;
GRANT FILE ON *.* TO 'littlesis'@'%' identified by 'themanbehindthemanbehindthethrone';
create database littlesis_test;
grant all privileges on littlesis_test.* to 'littlesis'@'%' identified by 'themanbehindthemanbehindthethrone';
flush privileges;
SQL

mysql -u littlesis -pthemanbehindthemanbehindthethrone -h 127.0.0.1 littlesis -e '\q'
