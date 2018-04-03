RAILS_DOCKER_VERSION := 0.4.0
PHP_DOCKER_VERSION := 0.0.7

help:
	@echo "Welcome to the LittleSis Dev Environment"

setup: rails config

rails:
	./scripts/clone.sh

config:
	cp config/rails/database.yml rails/config/database.yml
	cp config/rails/lilsis.yml rails/config/lilsis.yml

db-setup:
	mysql -h 127.0.0.1 -u root -proot < ./scripts/mysql_setup.sql
	echo "select now()" | mysql -u littlesis -pthemanbehindthemanbehindthethrone -h 127.0.0.1 littlesis

docker-pull:
	cat docker-compose.yml | grep "image:" | sed 's/image://g' | xargs -I image docker pull image


WORDPRESS_REPOS = littlesis-packages littlesis-core-functionality littlesis-news-theme
CLONE_URL = git@github.com:public-accountability

clone-wordpress-repos: blog
	cd blog && $(foreach repo,$(WORDPRESS_REPOS), git clone $(CLONE_URL)/$(repo).git;})


wordpress-setup: blog wordpress-download
	cp wp-config.php blog/wordpress/wp-config.php
	mkdir -v -p blog/wordpress/wp-content/uploads
	rsync -a wp-uploads/ blog/wordpress/wp-content/uploads/
	cd blog/littlesis-packages && composer install


wordpress-download:
	if ! test -f blog/wordpress/index.php; then \
		cd blog/wordpress && wp core download; \
	fi

blog:
	mkdir -v -p blog
	mkdir -v -p blog/wordpress


install-docker-on-ubuntu:
	sudo apt-get update && sudo apt-get install git apt-transport-https ca-certificates curl software-properties-common make
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(shell lsb_release -cs) stable"
	sudo apt-get update && sudo apt-get install docker-ce

build-rails-docker:
	docker build --no-cache -t aepyornis/ls-rails:$(RAILS_DOCKER_VERSION) -f littlesis.docker .

build-php-docker:
	docker build -t aepyornis/ls-php:$(PHP_DOCKER_VERSION) -f php.docker .


ansible-galaxy-roles:
	ansible-galaxy install rvm_io.ruby DavidWittman.redis geerlingguy.nodejs dev-sec.ssh-hardening geerlingguy.docker geerlingguy.composer


realip_conf := ./ansible/roles/littlesis/files/realip.conf

cloudflare-ips:
	curl -sSL "https://www.cloudflare.com/ips-v4" > /tmp/cloudflare-ips.txt
	curl -sSL "https://www.cloudflare.com/ips-v6" >> /tmp/cloudflare-ips.txt
	cat /tmp/cloudflare-ips.txt | ruby -ne 'print "set_real_ip_from #{$$_.delete("\n")};\n"' > $(realip_conf)
	echo 'real_ip_header X-Forwarded-For;' >> $(realip_conf)

.PHONY: help config db-setup
.PHONY: build-php-docker build-rails-docker docker-pull
.PHONY: ansible-galaxy-roles cloudflare-ips install-docker-on-ubuntu
.PHONY: wordpress-setup wordpress-download
