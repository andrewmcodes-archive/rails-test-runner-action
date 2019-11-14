#!/bin/sh

set -e
echo | lsof -i:5432
sh -c "$*"
