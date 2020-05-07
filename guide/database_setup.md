# Setting up the LittleSis database on new servers

## Transferring the production database to a new server

Obtain a full LittleSis backup, copy it to server (i.e. via scp) and then load the database:

``` sh
mysql -D littlesis < path/to/littlesis.sql
```

## Setup replication

### Prepare a backup

To transfer a backup from the main database to the replicant, I used a Digital Ocean volume like an external harddrive.

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

Start a mysql shell on replicant database and run:

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
