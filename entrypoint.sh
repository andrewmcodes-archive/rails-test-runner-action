#!/bin/sh -l

set -e
printenv
cd $GITHUB_WORKSPACE
gem update --system
gem install bundler --no-document
