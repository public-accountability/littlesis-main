# Running LittleSis in production

This document contains instructions for setting up LittleSis for production. It was created in Summer 2019 while moving our system from AWS to Digital Ocean. Although the document contains some Digital Ocean specific instructions, the ansible playbooks themselves are generic to Debian. It wouldn't be too hard to tweak these instructions to run on other service providers. I detest using the words "master" and "slave" when referring the database and instead I generally use the terms "main" database and "replicant" database.

## Architecture

LittleSis runs on 4 servers.

*app*  Runs the LittleSis rails app. 

*database* is a mariadb database server. Both the rails app and the wordpress use this database.

*replicant* is a replication of the database, primarily used as a backup.

*wordpress* runs our two wordpress sites.

## Setting up your own computer

You'll need ansible installed and an SSH key.

* To install ansible [see this guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html). 

* Create an ssh key to use just for LittleSis's deployment ```  ssh-keygen -t ed25519 ``` located at ` ~/.ssh/id_littlesis `

You are welcome to use an ssh key located elsewhere, but the default ansible variables assumes that location.

There is a Makefile in this folder with helpful shortcuts.

## Ansible vault

Two files -- inventory.yml and vars.yml -- are stored using ansible-vault.

edit these files with ` make inventory-edit ` and ` make vars-edit `.


## Create and setup servers

###  Create 4 debian buster servers

Currently at LittleSis.org, we use 2-4CPUs and 4-8GB RAM for the app, database, and replicant  servers. The wordpress servers can be smaller. To make matters easier the replicant server is kept as the same size of the main database server, but it could be smaller given that it's main function to operate as a backup.

Example inventory:

``` yaml
littlesis:
  children:
    app:
      hosts:
        x.x.x.x:
    database:
      hosts:
        x.x.x.x:
    wordpress:
      hosts:
        x.x.x.x:
    replicant:
      hosts:
        x.x.px.x:
  vars:
    ansible_python_interpreter: /usr/bin/python3
    ansible_ssh_common_args: '-o IdentitiesOnly=yes'
	ansible_user: root
    ansible_private_key_file: ~/.ssh/id_littlesis
```

Note that after the initial run, the host variable `ansible_user` should be changed from _root_ to _maintainer_.

You can update the ansible inventory via ` make inventory-edit `

### Update the vars

Run ` make vars-edit `. You'll need to change the `internal_ip` variables to correspend to the private networking IP from digital ocean. If setting up the app for development, you'll likely also want to change the server_name and TLS certs.

### run the playbook

` ansible-playbook littlesis.yml ` or ` make run `

## Load the production database

Obtain a full LittleSis backup, copy it to server (i.e. via scp) and then load the database:

``` sh
mysql -D littlesis < path/to/littlesis.sql
```

## Setup replication

### Prepare a backup 

To transfer a backup from the main database to the replicant we will transfer the files via a Digital Ocean volume, using the volume much like an external harddrive.

First create a DigitalOcean volume to store the backup on (~100gb), and then attach it to the main database droplet.

Mount the drive and create a backup folder:

``` sh
mkdir -p /mnt/backup
mount -o discard,defaults,noatime /dev/disk/by-id/scsi-0DO_Volume_dev-backup /mnt/backup
mkdir -p /mnt/backup/mariabackup
```

Now create the backup:

``` sh
mariabackup --backup --user=root --socket=/var/run/mysqld/mysqld.sock --target-dir=/mnt/backup/mariabackup --binlog-info=ON
```
When the backup is complete remove the drive mount ` umount /mnt/backup ` and detach the volume via DigitalOcean's dashboard.

### Copy the backup and restore the replicant

Attach the volume to the replicant droplet and repeat the mounting process on that server.

To restore the backup on the replicant server:

Stop mysqld ` systemctl stop mysql `

Empty the datadir `cd /var/lib/mysql/ && rm -r * `

Restore the backup: ` mariabackup --copy-back --target-dir=/mnt/backup/mariabackup `

Fix permissions: ` chown -R mysql:mysql /var/lib/mysql/ `

Restart mysqld: ` systemctl start mysql `

Write down the replication coordinates from backup folder

` cat /mnt/backup/mariabackup/xtrabackup_binlog_info `

It should look something like this: ` mariadb-bin.000163      713     0-1-331130 `

unmount the backup drive ` umount /mnt/backup `

You may now detach the Digital Ocean volume and delete it.

### Start the replication

Start mysql shell on replicant database and run:

replace "0-1-331130" with the actual number from the xtrabackup_binlog_info file and the host 
```
SET GLOBAL gtid_slave_pos = "0-1-331130";

CHANGE MASTER TO 
   MASTER_HOST="[internal_ip_database]", 
   MASTER_USER="replicant"
   MASTER_PASSWORD="[database_replicant_password]", 
   MASTER_USE_GTID=slave_pos;

START SLAVE;
```
