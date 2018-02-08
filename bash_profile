#!/bin/bash

cd /home/app/rails

if test -f ./spec/spec_bash_helper.sh; then
    source ./spec/spec_bash_helper.sh
fi
