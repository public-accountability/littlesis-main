#!/bin/sh
set -e

mkdir -v -p wordpress

for repo in littlesis-packages littlesis-core-functionality littlesis-news-theme
do
    sh -c "cd wordpress && git clone git@github.com:public-accountability/$repo.git"
done
