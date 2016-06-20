#!/bin/bash

/scripts/install-db.sh
/scripts/setup-rails.sh
/scripts/create-indexes.sh
/scripts/restart-all.sh
