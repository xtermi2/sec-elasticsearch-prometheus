#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

echo "stating docker-compose"
docker-compose up -d

./wait_until_started.sh

echo "executing testcases"
set -e
./test_case_cluster_health.sh
./test_case_prometheus_endpoint.sh
# TODO kibana is started
# TODO beats is shipping logs

docker-compose down
