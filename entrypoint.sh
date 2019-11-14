#!/bin/sh

set -e
chown -R $GITHUB_WORKSPACE && chmod -R 777 /app/bin
cd "$GITHUB_WORKSPACE" || exit
sh -c "$*"
