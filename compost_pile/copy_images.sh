#!/bin/sh

src_path=/home/ubuntu/images
dest_path=/var/www/littlesis/public/images

mkdir -p $dest_path

for folder in maps small group_logos campaign_covers campaign_covers/logos large system system/help toolkit square help profile face original; do
    mkdir -p $dest_path/$folder
done

for folder in maps group_logos campaign_covers campaign_covers/logos system system/help toolkit help face; do
    rsync -a -v $src_path/$folder/ $dest_path/$folder/
done


for folder in small profile large square; do
    find $src_path/$folder -type f |
	while read image_path
	do
	    
	    filename="${image_path##*/}"
	    dir_prefix=$(echo "$filename" | cut -c1-2)

	    mkdir -p "$dest_path/$folder/$dir_prefix"

	    dest_img_path="$dest_path/$folder/$dir_prefix/$filename"
	    cp $image_path $dest_img_path
	done
done
