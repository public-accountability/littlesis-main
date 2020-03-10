# LittleSis Development and Production Tasks

Helper scripts and how-to-dos for developing and running LittleSis.

These are tasks such as deploying changes, updating versions, and creating public database dumps, changing usernames.

[ansible/README.md](https://github.com/public-accountability/littlesis-main/blob/master/ansible/README.md) is a more detailed guide to setting up our production servers. Some of these are implemented as rake tasks (see `lib/` and `lib/tasks`), others are scripts in `lib/scripts`.

## Cache

### Clear Entire redis cache

This is only needed when things go really, really wrong.

``` sh
bundle exec rake runner "Rails.cache.clear"

```

### Update all Network Map Collections


Network Map Collections  are list of maps and the entities they contains. This is rendered on the LittleSis profile page sidebar.

``` sh
bundle exec rake maps:update_all_entity_map_collections
```

### Common names

``` sh
bundle exec rake common_names:warm_cache
```

## Database

### development Database

Create a new copy of the development database. Saves file to `data/development_db_[DATE].sql`

``` sh
bundle exec rake mysql:development_db
```


### public data

To dreate a new copy of public data dataset, run


``` sh
bundle exect rake mysql:public_data
```

which will create the file: ls_public_data_raw.sql.


Then copy that file to another computer with docker installed.

On that computer run:

``` sh
docker run -p 127.0.0.1:3306:3306 --name public-data -e MYSQL_ROOT_PASSWORD=littlesis -d mariadb:10.2
mysql -h 127.0.0.1 -u root -plittlesis -e 'create database littlesis'
zcat /path/to/ls_public_data_raw.sql.gz | mysql -h 127.0.0.1 -u root -plittlesis littlesis
mysql -h 127.0.0.1 -u root -plittlesis littlesis < /path/to/rails/lib/sql/clean_public_data.sql
mysqldump -h 127.0.0.1 -u root -plittlesis --skip-comments littlesis > public_data_`date +'%F'`.sql

```


## User management

### Changing a user's username:

In the rails console:

``` ruby
User.find_by(username: <OLD_USERNAME>).update!(username: <NEW_USERNAME>)
```

### Reset a user's password

``` ruby
User.find_by(email: <EMAIL>).send_reset_password_instructions
```

## Dependencies Updates

### Updating Oligrapher (OUTDATED)

1) Release a new version with a numeric tag -- i.e. `0.4.1`

2) In local dev environment, download latest version to static folder

``` fish
set OLIGRAPHER_VERSION [VERSION]
source ./scripts/download_oligrapher_version.fish
cd static/js/oligrapher && download_oli $OLIGRAPHER_VERSION
```

3) Add and commit the new files to this repo

4) Copy files to production server ` cd ansible && ansible-playbook site.yml --tags=static `

5) Change the variable `oligrapher_version` to new numeric tag number in `littlesis.yml`

6) Update the production server:  ` cd ansible && ansible-playbook site.yml --tags=config`

7) Restart rails: ` ssh littlesis '~/scripts/restart-rails' `

### Updating Ruby Versions

#### In development

1) **Change ruby versions** in these places:

- `rails/.ruby-version`
- `rails/.travis.yml`
- FROM line of `littlesis.docker`

2) **Run tests on new ruby version**

This can be done locally, but it's easier to just push the changes to a branch and let travis run with the new version.

3) **Create new docker image**

- bump `RAILS_DOCKER_VERSION` version in Makfile
- change version `docker-compose.yml`:
- build new docker: `make build rails docker`
- push docker images to docker hub: `docker push littlesis/littlesis:<RAILS_DOCKER_VERSION>`


#### In production

1) **Change ansible variable**

Change **ruby_version** in `ansible/group_vars/all`.

2) **Update server**

``` sh
ansible-playbook littlesis.yml --limit=app --tags=ruby
ansible-playbook littlesis.yml --limit=app --tags=clone
ansible-playbook littlesis.yml --limit=app --tags=gems
```

3) **restart puma on server**

then ssh-into the server and run:

``` sh
sudo systemctl restart littlesis
./scripts/rails-delayed-job-restart
```
