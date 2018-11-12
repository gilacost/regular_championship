#!/bin/ash

set -x
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

echo "Running $@"
exec "$@" > /dev/stdout
