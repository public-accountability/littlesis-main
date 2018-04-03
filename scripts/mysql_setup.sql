-- Main Littlesis Database
create database littlesis;
all privileges on littlesis.* to 'root'@'%' identified by 'root';
grant all privileges on littlesis.* to 'littlesis'@'%' identified by 'themanbehindthemanbehindthethrone' with grant option;
GRANT FILE ON *.* TO 'littlesis'@'%' identified by 'themanbehindthemanbehindthethrone';
-- Littlesis Test database
create database littlesis_test;
grant all privileges on littlesis_test.* to 'littlesis'@'%' identified by 'themanbehindthemanbehindthethrone';

-- wordpress database
create database eyes_on_the_ties;
grant all privileges on eyes_on_the_ties.* to 'wordpress'@'%' identified by 'wordpress' with grant option;

flush privileges;
