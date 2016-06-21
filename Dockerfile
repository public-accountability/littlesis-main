FROM ubuntu:14.04
MAINTAINER LittleSis Dev <dev@littlesis.org>

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update

# LAMP stack
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
RUN apt-get install -y lamp-server^
RUN apt-get install -y php-apc
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN echo "Listen 81" >> /etc/apache2/ports.conf
RUN a2enmod headers
RUN a2enmod rewrite
RUN a2enmod proxy
RUN a2enmod proxy_http

# php mail
RUN apt-get install -y php-pear
RUN pear install mail
RUN pear install Net_SMTP
RUN pear install Auth_SASL
RUN pear install mail_mime
RUN echo "postfix postfix/main_mailer_type string Internet site" | debconf-set-selections
RUN echo "postfix postfix/mailname string localhost" | debconf-set-selections
RUN apt-get -qqy install postfix

# nodejs
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get install -y nodejs

# imagemagick
RUN apt-get install -y imagemagick libmagickwand-dev

# phusion passenger
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
RUN apt-get install -y apt-transport-https ca-certificates
RUN echo "deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main" > /etc/apt/sources.list.d/passenger.list
RUN apt-get update
RUN apt-get install -y libapache2-mod-passenger

# memcached
RUN apt-get install -y memcached

# sphinx
RUN apt-get install -y sphinxsearch

# php5 extensions
RUN apt-get install -y php5-gd
RUN apt-get install -y php5-curl
RUN apt-get install -y php5-memcache

# curl
RUN apt-get install -y curl

# symfony
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN mkdir /usr/share/symfony
RUN echo "{ \"require\": { \"symfony/symfony1\": \"1.1.9\" } }" > /usr/share/symfony/composer.json
RUN cd /usr/share/symfony && composer install
RUN mv /usr/share/symfony/vendor/symfony/symfony1 /usr/share/symfony-1.1.9
RUN rm -rf /usr/share/symfony
RUN cp /usr/share/symfony-1.1.9/data/bin/symfony /usr/bin/
RUN chmod a+x /usr/bin/symfony

# misc
RUN apt-get install -y wget
RUN apt-get install -y nano

# apache virtualhost config
RUN wget https://raw.githubusercontent.com/skomputer/lilsis/master/config/littlesis-rails.conf -O /etc/apache2/sites-available/littlesis-rails.conf
RUN wget https://raw.githubusercontent.com/littlesis-org/littlesis/master/config/littlesis-symfony.conf -O /etc/apache2/sites-available/littlesis-symfony.conf
RUN cd /etc/apache2/sites-enabled && ln -s ../sites-available/littlesis-rails.conf
RUN cd /etc/apache2/sites-enabled && ln -s ../sites-available/littlesis-symfony.conf

# more stuff
RUN apt-get install -y qt5-default libqt5webkit5-dev g++
RUN apt-get install -y git
RUN apt-get install -y mysql-client libmysqlclient-dev

# ruby with rvm
RUN apt-get install -y libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -L https://get.rvm.io | bash -s stable
RUN source /etc/profile.d/rvm.sh
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.2.2"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"
RUN /bin/bash -l -c "rvm use 2.2.2 --default"
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN gem install bundler --no-ri --no-rdoc
RUN echo "source /etc/profile.d/rvm.sh" >> ~/.bashrc
RUN echo "export RAILS_ENV=development" >> ~/.bashrc
RUN source ~/.bashrc

# rails
RUN /bin/bash -l -c "rvm use 2.2.2 && gem install rails -v 4.1.10"

# change www-data UID so it can write to mounted volume
RUN usermod -u 1000 www-data

# install crontab from app repos
RUN (wget -qO- https://raw.githubusercontent.com/littlesis-org/littlesis/master/config/sample-crontab ; wget -qO- https://raw.githubusercontent.com/skomputer/lilsis/master/config/sample-crontab) | crontab -

# copy the database
COPY littlesis_db.sql /data/

# copy scripts
COPY scripts/ /scripts/

# Install DB
RUN /bin/bash -l /scripts/install-db.sh

WORKDIR ~/
