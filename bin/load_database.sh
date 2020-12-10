#!/bin/sh

sql_file="$1"

if ! test -f "$sql_file"
then
    echo "$sql_file is not a file"
    exit 1
fi

mysql -u littlesis -pthemanbehindthemanbehindthethrone -h 127.0.0.1 littlesis < "$sql_file"
