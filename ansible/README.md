# System Administration for LittleSis using Ansible


This document contains instructions for setting up servers to run LittleSis configured with ansible.

## History

Until 2019 LittleSis ran on Amazon Web Services until it was moved to Digital Ocean. Although the document contains some Digital Ocean specific instructions, the ansible playbooks themselves do not contain any hosting-provider specific features. It wouldn't be too hard to tweak these instructions to run on other hosting providers.

## Servers

LittleSis runs on 4 servers, all installed with the Debian operating system

| Name        | Description                  |
|:------------|:-----------------------------|
| *app*       | LittleSis rails application  |
| *database*  | MariaDB Database Sever       |
| *replicant* | Replication copy of database |
| *wordpress* | Wordpress Sites              |


## Developer computer setup
### Requirements and SSH key creation

You'll need ansible installed and an SSH key.

* To install ansible [see this guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).

* Create an ssh key to that will be used for LittleSis's deployment ```  ssh-keygen -t ed25519 ``` located at ` ~/.ssh/id_littlesis `

You are welcome to use an ssh key located elsewhere, but the default ansible variable assumes that location. It is important to keep this file safe and backed-up because it is your password to the server.

There is a Makefile in this folder with helpful shortcuts.

### Ansible Vault

Ansible vault is used to store variable secrets -- passwords, api keys, etc. Only two files, inventory.yml and vars.yml, are stored using ansible-vault.

Edit these files with ` make inventory-edit ` and ` make vars-edit `.

## Setup new production servers
### Create servers and setup inventory

Currently LittleSis.org uses 2-4CPUs and 4-8GB RAM servers for the app, database, and replicant servers. The wordpress server can be smaller. For simplicity's sake, the replicant server is kept as the same size of the main database server, which could probably be smaller given that it's main function to operate as a backup and it mostly sits idle.

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
    replicant:
      hosts:
        x.x.x.x::
    wordpress:
      hosts:
        x.x.x.x:

  vars:
    ansible_python_interpreter: /usr/bin/python3
    ansible_ssh_common_args: '-o IdentitiesOnly=yes'
    ansible_user: root
    ansible_private_key_file: ~/.ssh/id_littlesis
```

**After the initial run, the host variable `ansible_user` should be changed from _root_ to _maintainer_.**

You can update the ansible inventory via ` make inventory-edit `

### Updating the variables

Run ` make vars-edit `. You'll need to change the `internal_ip` variables to correspond to the private networking IP from digital ocean. If setting up the app for development, you'll likely also want to change the server_name and TLS certs.

### Run the playbooks

` ansible-playbook littlesis.yml ` or ` make run `

### Database and Replication

## Transferring the production database to a new server

``` sh
mysql -D littlesis < path/to/littlesis.sql
```

### Replication Setup

### Prepare a backup

Before starting the replication, mariabackup is used to make a copy of the primary database files. To transfer the mysql data (~100gb), these instructions used a Digital Ocean volume like an external harddrive, but you could transfer those files using ssh or some other mechanism.

*create a DigitalOcean volume* to store the backup files on. Attach it to the main database droplet.

Mount the drive and create a backup folder, replacing __scsi-0DO_Volume_dev-backup__ with the name of the volume.

``` sh
mkdir -p /mnt/backup
mount -o discard,defaults,noatime /dev/disk/by-id/scsi-0DO_Volume_dev-backup /mnt/backup
mkdir -p /mnt/backup/mariabackup
```

Run `mariabackup`

``` sh
mariabackup --backup --user=root --socket=/var/run/mysqld/mysqld.sock --target-dir=/mnt/backup/mariabackup --binlog-info=ON
```

When the backup is complete remove the drive mount ` umount /mnt/backup ` and detach the volume via DigitalOcean's dashboard.

### Copy the backup and restore the replicant

Attach the volume to the replicant droplet and repeat the mounting process on that server.

To restore the backup on the replicant server:

Stop the database ` systemctl stop mariadb `

Empty the datadir `cd /var/lib/mysql/ && rm -r * `

Restore the backup: ` mariabackup --copy-back --target-dir=/mnt/backup/mariabackup `

Fix permissions: ` chown -R mysql:mysql /var/lib/mysql/ `

Restart mysqld: ` systemctl start mariadb `

Write down the replication coordinates from backup folder

` cat /mnt/backup/mariabackup/xtrabackup_binlog_info `

It should look something like this: ` mariadb-bin.000163      713     0-1-331130 `

unmount the backup drive ` umount /mnt/backup `

You may now detach the Digital Ocean volume and delete it.

### Start the replication

Start a mysql shell on replicant database and run:

replace "0-1-331130" with the actual number from the xtrabackup_binlog_info file and make sure to change the host and password.

```
SET GLOBAL gtid_slave_pos = "0-1-331130";

CHANGE MASTER TO
   MASTER_HOST="[internal_ip_database]",
   MASTER_USER="replicant",
   MASTER_PASSWORD="[database_replicant_password]",
   MASTER_USE_GTID=slave_pos;

START SLAVE;
```

Use `SHOW SLAVE STATUS\G` to see if it's running properly

## Ansible tasks and tips

Depending how you configured ansible, you'll likely have to add these two flags when running `ansible-playbook`

``` sh
ansible-playbook --ask-become-pass --ask-vault-pass
```

### Common ansible tasks after install:

**Update nginx configuration:**


``` sh
ansible-playbook app.yml --tags=nginx-config
```

**Update rails configuration**


``` sh
ansible-playbook app.yml --tags=rails-config
```

**Add or Update static files**

``` sh
ansible-playbook app.yml --tags=static
```

**Update maintainer scripts**


``` sh
ansible-playbook app.yml --tags=scripts
```


**Add new maintainer ssh key**

Add the new ssh public key to the list stored in variable `maintainer_authorized_keys` :

``` sh
make vars-edit
```

Then run:

``` sh
ansible-playbook littlesis.yml --tags=user
```
