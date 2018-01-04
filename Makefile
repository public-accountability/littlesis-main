RAILS_DOCKER_VERSION := 0.3.1
PHP_DOCKER_VERSION := 0.0.6

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

install-docker-on-ubuntu:
	sudo apt-get update
	sudo apt-get install git apt-transport-https ca-certificates curl software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	sudo apt-get update && sudo apt-get install docker-ce

build-rails-docker:
	docker build --no-cache -t aepyornis/ls-rails:$(RAILS_DOCKER_VERSION) -f littlesis.docker .


ansible-galaxy-roles:
	ansible-galaxy install rvm_io.ruby DavidWittman.redis geerlingguy.nodejs dev-sec.ssh-hardening geerlingguy.docker geerlingguy.composer

.PHONY: help config build-rails-docker docker-pull db-setup
