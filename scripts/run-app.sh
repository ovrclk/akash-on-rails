#!/bin/bash

set -e

export RAILS_ENV=production
export RAILS_SERVE_STATIC_FILES=true

/scripts/restore-postgres.sh

rake db:create db:migrate db:seed

rake assets:precompile

bundle exec rails s -e production
