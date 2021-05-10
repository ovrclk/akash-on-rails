#!/bin/bash

set -e

export RAILS_ENV=production
export RAILS_SERVE_STATIC_FILES=true

rake assets:precompile

bundle exec rails s -e production
