# littlesis-docker

Rails Code: https://github.com/public-accountability/littlesis-rails

Symfony Code: https://github.com/littlesis-org/littlesis

Oligrapher: https://github.com/skomputer/oligrapher

Steps for a fully functional LittleSis Development environment:

* Initial setup: download repos, configure files, pull docker images, launch the containers
* Load database
* Setup test database and rails tests
* Setup and start Sphinx
* Setup javascript tests

## Helper program: ./littlesis

There's a helper bash program that will let you easily interact with the docker containers to do common tasks such as running rails console, running tests, starting sphinx, and viewing logs without having to remember esoteric docker & bash commands.

To see the script's features run: ``` ./littlesis help ```

## Initial setup

1) Pull down the repos: ``` ./apps.sh ```

2) Edit the configuration files or obtain a copy of the configuration files and run ``` ./config.sh ```

3) Modify paths in docker-compose.yml if need [otherwise skip this step] 
   
4) run app: ``` docker-compose up ```

To enter the Rails container use: ``` ./docker_login rails ```

To enter the Symfony container use: ``` ./docker_login php ``` 

## Setup the database

``` mysql_setup.sql ``` creates the databases littlesis and littlesis_test and creates the user 'littlesis'

``` bash
mysql -h 127.0.0.1 -u root -proot < ./mysql_setup.sql

```

If you have an existing copy of LittleSis's database, populate the database now:

``` bash
mysql -u littlesis -pthemanbehindthemanbehindthethrone -h 127.0.0.1 littlesis < path/to/littlesis_db.sql
```

This can take anywhere from 30mins to 3 hours depending on the size of the database dump.

## Setup Rails tests

Enter the rails container: ``` ./docker_login rails ``` and then run the tests:

``` bash
su - app
cd ~/lilsis
# setup the test database
RAILS_ENV=test bundle exec rake db:structure:load
# run the tests
RAILS_ENV=test bundle exec rspec
# There is a helper bash function -- spec -- located at spec/spec_bash_helper.sh
# source this file in order to use the helper function
source ./spec/spec_bash_helper.sh
# now to run the tests you can use the shortcut:
spec
```

## Setup and start Sphinx

Both Rails and Symfony use their own version of Sphinx. The first time you create the containers (and anytime you rebuild a container) you'll have to re-index both versions of Sphinx. _Everytime_ you start the docker app, you will have to start sphinx. If you get the error page on a profile page, make sure that sphinx is started.

To start and index PHP's sphinx:

``` bash
# go inside the php container
./docker_login php
# index sphinx 
# Indexing is not required if the index files already exist
# Although there's no harm to re-indexing
/scripts/index_php_sphinx.sh
# start sphinx 
/scripts/start_php_sphinx.sh
```

To start and index Rail's sphinx:

``` bash
# go inside the rails container
./docker_login rails
su - app
cd ~/lilsis
# index and start sphinx
bundle exec rake ts:rebuild
# If the indexes already exists you don't have to 
# rebuild them, you can just run:
bundle exec rake ts:restart
```

## Setup Javascript tests

Make symlinks and install javascript libraries:

``` bash
# log into rails docker
./docker_login rails
# in docker container:
cd /home/app/lilsis
ln -s $(realpath vendor) ./test/vendor
ln -s $(realpath app/assets) ./test/assets
# install node modules
cd /home/app/lilsis/test
npm install
```

View tests at _ls.dev:8080/test/runner.html_

### Docker images

The php dockerfile is php.docker and the Rails dockerfile is passenger.docker.

After updating the dockerfiles or after adding a new gem, change the tags in build-docker and then build the docker images: ``` ./build-docker.sh ``` and upload the new images to Docker Hub. See [here for dockerhub instructions](https://docs.docker.com/engine/getstarted/step_six/). 

### Linked Docker Volumes

./apps/rails -> rails code + repo

./apps/symfony -> symfony code + repo

./mysql-data -> mysql database data

./chat/uploads -> rocket chat uploads

./chat/db -> rocket chat mongo db data


### Nginx configuration

The file _ls_dev.conf_ contains the nginx configuration. The app is accessible at ``` localhost:8080 ``` and, additionally, if you add these two lines to  ``` /etc/hosts ``` :

```
127.0.0.1	ls.dev
127.0.0.1	lsapi.dev
```

you can access the site at ``` ls.dev:8080 ```

### Useful logs

*Nginx logs*
  - /var/log/nginx/access.log
  - /var/log/nginx/error.log

*Rails logs*:
   - /home/app/lilsis/log/development.log


