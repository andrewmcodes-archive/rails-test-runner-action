#!/bin/sh

set -e
cd "$GITHUB_WORKSPACE" || exit
sh -c "$*"
