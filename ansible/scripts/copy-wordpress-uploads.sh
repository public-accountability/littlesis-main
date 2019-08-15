#!/bin/sh
set -eu
# This extracts the wp-content/uploads folder from an
# archive of the wordpress folder and uploads them to the server.
#
# arg 1: path to archive
# arg 2: name of wordpress host configured ssh/config
#
# copy-wordpress-uploads.sh data/wordpress-files-2019-07-22.tar.gz litttelsis-wordress
archive_path="$1"
ssh_host="$2"
local_tmp_dir=$(mktemp -d)
remote_tmp_dir=$(ssh $ssh_host "mktemp -d")

tar -x -f $archive_path  -C $local_tmp_dir --strip-components=3 ./wp-content/uploads/

rsync -a -v -e 'ssh' "$local_tmp_dir/" "$ssh_host:$remote_tmp_dir/"

ssh -t $ssh_host "sudo rsync -a -v $remote_tmp_dir/ /var/www/wordpress/wordpress/wp-content/uploads/"
