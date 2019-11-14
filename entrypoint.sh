#!/bin/sh -l

set -e
cd $GITHUB_WORKSPACE
gem update --system
gem install bundler --no-document
bundle install --jobs 4 --retry 3 --quiet
yarn install --frozen-lockfile
bundle exec rails db:prepare && bundle exec rails test
