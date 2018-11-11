#!/bin/ash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace


echo "Running /opt/app/bin/start_server foreground"
exec "$@"



