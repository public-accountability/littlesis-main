create database littlesis;
grant all privileges on littlesis.* to 'root'@'%' identified by 'root';
grant all privileges on littlesis.* to 'littlesis'@'%' identified by 'themanbehindthemanbehindthethrone' with grant option;
GRANT FILE ON *.* TO 'littlesis'@'%' identified by 'themanbehindthemanbehindthethrone';
create database littlesis_test;
grant all privileges on littlesis_test.* to 'littlesis'@'%' identified by 'themanbehindthemanbehindthethrone';
flush privileges;
