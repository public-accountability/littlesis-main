RAILS_DOCKER_VERSION := 1.1.4

help:
	@echo "Welcome to the LittleSis Dev Environment"

setup: rails config

rails:
	./scripts/clone.sh
	mkdir -p docker docker/tmp docker/log

config:
	rsync -a config/ rails/config/

sample_config:
	cp config/lilsis.yml rails/config/lilsis.yml.sample
	cp config/secrets.yml rails/config/secrets.yml.sample

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
	docker build --no-cache -t littlesis/littlesis:$(RAILS_DOCKER_VERSION) -f littlesis.docker .

realip_conf := ./ansible/roles/app/files/realip.conf

cloudflare-ips:
	curl -sSL "https://www.cloudflare.com/ips-v4" > /tmp/cloudflare-ips.txt
	curl -sSL "https://www.cloudflare.com/ips-v6" >> /tmp/cloudflare-ips.txt
	cat /tmp/cloudflare-ips.txt | ruby -ne 'print "set_real_ip_from #{$$_.delete("\n")};\n"' > $(realip_conf)
	echo 'real_ip_header X-Forwarded-For;' >> $(realip_conf)


.PHONY: help setup rails config db-setup docker-pull
.PHONY: clone-wordpress-repos build-rails-docker cloudflare-ips
