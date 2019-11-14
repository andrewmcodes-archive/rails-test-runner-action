#!/bin/sh

set -e
lsof -i:5432
sh -c "$*"
