# System Administration for LittleSis using Ansible

This document contains instructions for setting up servers to run LittleSis configured with ansible.

## Server Overview

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

A few roles from ansible galaxy must also be installed: `ansible-galaxy install dev-sec.ssh-hardening dev-sec.os-hardening geerlingguy.nodejs geerlingguy.composer`

### Ansible Vault

Ansible vault is used to store variable secrets -- passwords, api keys, etc. Only three files, inventory.yml, vars.yml, and vars-staging.yml are stored using ansible-vault.

You can edit and view theses files with `ansible-vault`. Example: `ansible-vault edit vars.yml`

## Setup new production servers

Currently LittleSis.org uses 2-4CPUs and 4-8GB RAM servers for the app, database, and replicant servers. The wordpress server can be smaller.

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


` ansible-playbook littlesis.yml ` will run all playbooks. Each group can also be run on it's own `ansible-playbook app.yml`

**After the initial run, the host variable `ansible_user` should be changed from _root_ to _maintainer_.**

## Database and Replication

### Transferring the production database to a new server

Obtain a full backup of the database and load the file into mariadb: ` mysql -D littlesis < path/to/littlesis.sql `

### Replication

### Prepare a backup

Before starting the replication, mariabackup is used to make a copy of the primary database files. To transfer the mysql data (~100gb), these instructions use a Digital Ocean volume like an external harddrive, but you could transfer those files using rsync, scp, or some other mechanism.

- Create a DigitalOcean volume to store the backup files on. Attach it to the main database droplet.

- Mount the drive and create a backup folder, replacing __scsi-0DO_Volume_dev-backup__ with the name of the volume.

    ``` sh
    mkdir -p /mnt/backup
    mount -o discard,defaults,noatime /dev/disk/by-id/scsi-0DO_Volume_dev-backup /mnt/backup
    mkdir -p /mnt/backup/mariabackup
    ```

- Run `mariabackup`

    ``` sh

mariabackup --backup --user=root --socket=/var/run/mysqld/mysqld.sock --target-dir=/mnt/backup/mariabackup --binlog-info=ON
mariabackup --prepare --target-dir=/mnt/backup/mariabackup

    ```

- When the backup is complete remove the drive mount ` umount /mnt/backup ` and detach the volume via DigitalOcean's dashboard.

### Copy the backup and restore the replicant

- Attach the volume to the replicant droplet and repeat the mounting process on that server.

- Restore the backup on the replicant server:
  - Stop the database ` systemctl stop mariadb `
  - Empty the datadir `cd /var/lib/mysql/ && rm -r * ` (Note: the datadir *might* be at a different path)
  - Restore the backup: ` mariabackup --copy-back --target-dir=/mnt/backup/mariabackup `
  - Fix permissions: ` chown -R mysql:mysql /var/lib/mysql/ `
  - Restart mysqld: ` systemctl start mariadb `
  - Write down the replication coordinates from backup folder: ` cat /mnt/backup/mariabackup/xtrabackup_binlog_info `
  - It should look something like this: ` mariadb-bin.000163      713     0-1-331130 `
  - umount the backup drive ` umount /mnt/backup `

- You may now detach the Digital Ocean volume and delete it

### Start the replication

Start a mysql shell on the replicant database and run these sql commands:

Replace "0-1-331130" with the actual number from the xtrabackup_binlog_info file and make sure to change the host and password.

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

## Using Ansible to manage running servers

**Check if servers are online:** `ansible littlesis -m ping`

**View inventory:** `ansible-inventory --graph`

**Update nginx configuration:**  `ansible-playbook app.yml --tags=nginx-config`

**Update rails configuration:**  `ansible-playbook app.yml --tags=rails-config`

**Add or Update static files:**  `ansible-playbook app.yml --tags=static`

**Update maintainer scripts:**  `ansible-playbook app.yml --tags=scripts`

To **add additional maintainer ssh keys**, append the new public key to the list stored in the variable *maintainer_authorized_keys* and then run `ansible-playbook littlesis.yml --tags=user`
