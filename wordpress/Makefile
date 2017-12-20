setup: docker-pull littlesis-packages composer

docker-pull:
	docker pull wordpress:4.9.1-apache
	docker pull mariadb:10.1

littlesis-packages:
	git clone git@github.com:public-accountability/littlesis-packages.git

composer:
	cd littlesis-packages && composer install

.PHONY: setup docker-pull composer
