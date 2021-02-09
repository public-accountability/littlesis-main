FROM ruby:2.7.2-buster
LABEL maintainer="dev@littlesis.org"

RUN apt-get update && apt-get upgrade -y && \
	apt-get -y install \
	build-essential \
	coreutils \
        curl \
        csvkit \
	git \
	gnupg \
	grep \
	imagemagick \
	iproute2 \
	libmagickwand-dev \
	lsof \
	redis-tools \
	software-properties-common \
	sqlite3 \
	unzip \
	zip \
        libdbus-glib-1-dev \
        libsqlite3-dev

RUN apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
RUN add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.5/debian buster main'
RUN apt-get update && apt-get -y install mariadb-client libmariadb-dev

# Manticore
RUN curl -sSL https://repo.manticoresearch.com/repository/manticoresearch_buster/pool/m/manticore/manticore_3.5.4-201211-13f8d08d_amd64.deb > /tmp/manticore.deb
RUN echo 'cb7d8105067fa5822aa7e85d11ab4208db1f1976793c1f31b621f0b148b48ee8  /tmp/manticore.deb' | sha256sum -c -
RUN apt-get install -y /tmp/manticore.deb

# Node
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

# YARN
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN add-apt-repository "deb https://dl.yarnpkg.com/debian/ stable main"
RUN apt-get update && apt-get -y install yarn

# Chrome and Chrome Driver
RUN curl -L "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" > /tmp/chrome.deb
RUN apt-get install -y /tmp/chrome.deb && google-chrome --version
RUN curl -L "https://chromedriver.storage.googleapis.com/87.0.4280.20/chromedriver_linux64.zip" > /tmp/chromedriver.zip
RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/bin
RUN chown root:root /usr/bin/chromedriver && chmod +x /usr/bin/chromedriver && chromedriver --version

# Firefox and Geckodriver
RUN curl -L "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US" | tar xjf - -C /opt
RUN printf "#!/bin/sh\nexec /opt/firefox/firefox \$@\n" > /usr/local/bin/firefox && chmod +x /usr/local/bin/firefox && firefox -version
RUN curl -L "https://github.com/mozilla/geckodriver/releases/download/v0.28.0/geckodriver-v0.28.0-linux64.tar.gz" | tar xzf - -C /usr/local/bin

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
