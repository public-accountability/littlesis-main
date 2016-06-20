#!/bin/bash

mkdir -p littlesis-apps
cd littlesis-apps
mkdir symfony && cd symfony && git clone git@github.com:littlesis-org/littlesis.git . && ./setup.sh
cd ..
mkdir rails && cd rails && git clone git@github.com:skomputer/lilsis.git . && ./setup.sh

