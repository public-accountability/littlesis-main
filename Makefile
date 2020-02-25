RAILS_DOCKER_VERSION := 0.9.19

help:
	@echo "Welcome to the LittleSis Dev Environment"

setup: rails config

rails:
	./scripts/clone.sh

config:
	cp config/database.yml rails/config/database.yml
	cp config/lilsis.yml rails/config/lilsis.yml

db-setup:
	mysql -h 127.0.0.1 -u root -proot < ./scripts/mysql_setup.sql
	echo "select now()" | mysql -u littlesis -pthemanbehindthemanbehindthethrone -h 127.0.0.1 littlesis

docker-pull:
	cat docker-compose.yml | grep "image:" | sed 's/image://g' | xargs -I image docker pull image

WORDPRESS_REPOS = littlesis-packages littlesis-core-functionality littlesis-news-theme
CLONE_URL = git@github.com:public-accountability

clone-wordpress-repos:
	mkdir -v -p wordpress
	cd wordpress && $(foreach repo,$(WORDPRESS_REPOS), git clone $(CLONE_URL)/$(repo).git;})

build-rails-docker:
	docker build --no-cache -t aepyornis/ls-rails:$(RAILS_DOCKER_VERSION) -f littlesis.docker .

ansible-galaxy-roles:
	ansible-galaxy install rvm.ruby DavidWittman.redis geerlingguy.nodejs dev-sec.ssh-hardening dev-sec.os-hardening geerlingguy.docker geerlingguy.composer

realip_conf := ./ansible/roles/app/files/realip.conf

cloudflare-ips:
	curl -sSL "https://www.cloudflare.com/ips-v4" > /tmp/cloudflare-ips.txt
	curl -sSL "https://www.cloudflare.com/ips-v6" >> /tmp/cloudflare-ips.txt
	cat /tmp/cloudflare-ips.txt | ruby -ne 'print "set_real_ip_from #{$$_.delete("\n")};\n"' > $(realip_conf)
	echo 'real_ip_header X-Forwarded-For;' >> $(realip_conf)


.PHONY: help setup rails config db-setup docker-pull
.PHONY: clone-wordpress-repos build-rails-docker ansible-galaxy-roles cloudflare-ips
