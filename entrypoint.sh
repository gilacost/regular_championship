#!/bin/ash

set -x
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

export HOSTNAME="`ifconfig eth0 | sed -n '/inet addr/s/.*addr.\([^ ]*\) .*/\1/p'`" > /dev/stdout

echo "Running $@"
exec "$@" > /dev/stdout
