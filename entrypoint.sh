#!/bin/sh

set -e
echo printenv
sh -c "bundle exec rails test"
