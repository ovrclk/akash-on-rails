#!/bin/bash

set -e

export RAILS_SERVE_STATIC_FILES=true
export SECRET_KEY_BASE=$(rake secret)

rake assets:precompile

bundle exec rails s -e production
