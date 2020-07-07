#!/bin/bash

mkdir -p rails

if ssh -o StrictHostKeyChecking=no -T git@github.com 2>&1 | grep -q 'successfully authenticated';then
    URL="git@github.com:public-accountability/littlesis-rails.git"
else
    URL="https://github.com/public-accountability/littlesis-rails.git"
fi

cd rails && git clone $URL .
