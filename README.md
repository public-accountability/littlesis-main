# littlesis-docker

Pull down the repos: ``` ./apps.sh ```

Edit the configuration files.

Build the docker images: ``` ./build-docker.sh ```

Modify paths in docker-compose.yml as needed. 

run app: ``` docker-compose up ```

----------------------------------------------------------
**Old Instructions**

to install the littlesis database:

``` bash
mysql "create database littlesis;"
mysql -e "grant all privileges on littlesis.* to 'littlesis'@'localhost' identified by 'password';"
mysql -u littlesis -ppassword littlesis < /path/to/littlesis_db.sql
mysql -u littlesis -ppassword littlesis < /path/to/os_donations.sql
```

Pull down the repos: ``` ./apps.sh ```

Build the docker image: ``` ./build-docker.sh ```

Start the container: ``` ./start-docker.sh ``` 

*Setup mysql networking:*

Find out what is the ip address of the docker host:

```
ip addr show docker0

```
Look for the line similar to this: ``` inet 172.17.0.1/16 scope global docker0 ```

Afterwards change the bind-address in my.conf to be that ip address. On Debian this is located at /etc/mysql/my.cnf.

```
bind-address		= 172.17.0.1
```

Afterwards restart mysql: sudo service mysql restart

If you use mysql with other apps they might have problems connecting to it. 

After building the docker image, running the image, & attaching to it, inside the docker, find out what the container's ip address is:

``` 
ip addr show eth0
```

And then give the littlesis user database permissions, putting the container's ip address after the @:

``` sql
GRANT ALL PRIVILEGES ON littlesis.* To 'littlesis'@'xxx.xx.xx' identified by 'password';

```

Install gems and create sphnix indexes. Run this *inside* the container:

``` bash
/scripts/setup.sh
```


