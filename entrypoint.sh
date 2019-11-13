#!/bin/sh

set -e
echo printenv
sh -c "bundle exec rails db:prepare && bundle exec rails test"
