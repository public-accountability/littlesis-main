#!/bin/bash

mysql -u root -proot -e "create database littlesis_test;"
# assumes user littlesis exists
mysql -u root -proot -e "grant all privileges on littlesis_test.* to 'littlesis'@'localhost';"
