#!/bin/bash

indexer --config /var/www/littlesis/symfony/config/sphinx.conf entities lists notes
indexer --config /var/www/littlesis/symfony/config/sphinx.conf entities_delta lists_delta notes_delta
