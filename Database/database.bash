#!/usr/bin/env bash

set -e

echo 'Creating types...'
psql --quiet --set ON_ERROR_STOP= -f types.sql > /dev/null

echo 'Creating tables...'
psql --quiet --set ON_ERROR_STOP= -f tables.sql > /dev/null

echo 'Creating constraints...'
psql --quiet --set ON_ERROR_STOP= -f constraints.sql > /dev/null

echo 'Adding views...'
psql --quiet --set ON_ERROR_STOP= -f views.sql > /dev/null

echo 'Adding functions...'
psql --quiet --set ON_ERROR_STOP= -f functions.sql > /dev/null

echo 'Adding default data...'
psql --quiet --set ON_ERROR_STOP= -f default_data.sql > /dev/null
