#!/bin/bash

# rails config files
cp config/rails/database.yml apps/rails/config/database.yml
cp config/rails/lilsis.yml apps/rails/config/lilsis.yml
# symfony config files
cp config/symfony/databases.yml apps/symfony/config/database.yml
cp config/symfony/frontend/app.yml apps/symfony/apps/frontend/config/app.yml
cp config/symfony/frontend/settings.yml apps/symfony/apps/frontend/config/settings.yml
# symfony sphinx
cp config/symfony/sphinx.conf apps/symfony/config/sphinx.conf
