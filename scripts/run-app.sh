#!/bin/bash

set -e

export SECRET_KEY_BASE=$(rake secret)

rake assets:precompile

rails s -b 0.0.0.0
