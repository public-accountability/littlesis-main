RAILS_DOCKER_VERSION := 0.2.1
PHP_DOCKER_VERSION := 0.0.6

help:
	@echo "Welcome to the LittleSis Dev Environment"

apps:
	mkdir -p apps
	cd apps && mkdir symfony && cd symfony && git clone git@github.com:littlesis-org/littlesis.git . && ./setup.sh
	cd apps && mkdir rails && cd rails && git clone git@github.com:public-accountability/littlesis-rails.git . && ./setup.sh

config:
#       rails config files
	cp config/rails/database.yml apps/rails/config/database.yml
	cp config/rails/lilsis.yml apps/rails/config/lilsis.yml
#       symfony config files
	cp config/symfony/databases.yml apps/symfony/config/databases.yml
	cp config/symfony/frontend/app.yml apps/symfony/apps/frontend/config/app.yml
	cp config/symfony/frontend/settings.yml apps/symfony/apps/frontend/config/settings.yml
#       symfony sphinx
	cp config/symfony/sphinx.conf apps/symfony/config/sphinx.conf

db-setup:
	mysql -h 127.0.0.1 -u root -proot < ./mysql_setup.sql
	echo "select now()" | mysql -u littlesis -pthemanbehindthemanbehindthethrone -h 127.0.0.1 littlesis

docker-pull:
	cat docker-compose.yml | grep "image:" | sed 's/image://g' | xargs -I image docker pull image

build-rails-docker:
	docker build --no-cache -t aepyornis/ls-rails:$(RAILS_DOCKER_VERSION) -f passenger.docker .

build-php-docker:
	docker build -t aepyornis/ls-php:v$(PHP_DOCKER_VERSION) -f php.docker .

.PHONY: help config build-rails-docker build-php-docker docker-pull
.PHONY: db-setup
