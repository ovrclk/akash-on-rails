#!/bin/bash

set -e

export SECRET_KEY_BASE=$(rake secret)

# prepare and restore database
rake db:create
/scripts/restore-postgres.sh
rake db:migrate db:seed

# make env accessible to cron
declare -p | grep -Ev 'BASHOPTS|BASH_VERSINFO|EUID|PPID|SHELLOPTS|UID' > /container.env

# add our crontab
whenever --update-crontab

echo "Starting cron"
cron -f
