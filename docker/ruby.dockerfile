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
	libmagickwand-dev \
	lsof \
	redis-tools \
        sqlite3 \
        libsqlite3-dev \
	unzip \
	zip \
        libdbus-glib-1-dev \
        postgresql-client \
        pgloader

# Manticore
RUN curl -sSL https://repo.manticoresearch.com/repository/manticoresearch_buster/pool/m/manticore/manticore_3.5.4-201211-13f8d08d_amd64.deb > /tmp/manticore.deb
RUN echo 'cb7d8105067fa5822aa7e85d11ab4208db1f1976793c1f31b621f0b148b48ee8  /tmp/manticore.deb' | sha256sum -c -
RUN apt-get install -y /tmp/manticore.deb

# Node
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs
RUN npm --global install yarn

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

RUN apt-get clean && rm -rf /tmp/*
