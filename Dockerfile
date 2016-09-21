FROM ubuntu:14.04
MAINTAINER LittleSis Dev <dev@littlesis.org>
# UPDATE & UPGRADE
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update
RUN apt-get -y upgrade
# UTILITIES
RUN apt-get install -y emacs nano curl wget git screen htop gnupg build-essential imagemagick libmagickwand-dev qt5-default libqt5webkit5-dev g++ libcurl4-gnutls-dev libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
# MYSQL CLIENT
RUN apt-get install -y mysql-client libmysqlclient-dev
# PHP
RUN apt-get install -y php5-fpm php-apc php5-mysql php5-gd php5-curl php5-memcache
# PHP MAIL
RUN apt-get install -y php-pear
RUN pear install mail
RUN pear install Net_SMTP
RUN pear install Auth_SASL
RUN pear install mail_mime
RUN echo "postfix postfix/main_mailer_type string Internet site" | debconf-set-selections
RUN echo "postfix postfix/mailname string localhost" | debconf-set-selections
RUN apt-get -qqy install postfix
# NODEJS
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash -
RUN apt-get update
RUN apt-get install -y nodejs
RUN ln -sf /usr/bin/nodejs /usr/local/bin/node
# get add-apt-repository    
RUN apt-get install -y software-properties-common python-software-properties    
# SPHNIX
RUN add-apt-repository ppa:builds/sphinxsearch-rel22
RUN apt-get update
RUN apt-get install -y sphinxsearch
# REDIS & MEMACHE
RUN apt-get install -y memcached
RUN apt-get install -y redis-server
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
# NGINX
RUN apt-get install -y nginx
# PASSENGER
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
RUN apt-get install -y apt-transport-https ca-certificates
RUN sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main > /etc/apt/sources.list.d/passenger.list'
RUN apt-get update
RUN apt-get install -y passenger
# RVM
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN source /etc/profile.d/rvm.sh
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.3.1"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"
RUN /bin/bash -l -c "rvm use 2.3.1 --default"
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN gem install bundler --no-ri --no-rdoc
RUN echo "source /etc/profile.d/rvm.sh" >> ~/.bashrc
# bashrc
RUN echo "export RAILS_ENV=development" >> ~/.bashrc
RUN echo "export XTERM=xterm" >> ~/.bashrc
RUN source ~/.bashrc   
# RAILS
RUN /bin/bash -l -c "rvm use 2.3.1 && gem install rails -v 4.1.8"
# change www-data UID so it can write to mounted volume
RUN usermod -u 1000 www-data
# copy scripts
COPY scripts/ /scripts/
WORKDIR ~/
        
