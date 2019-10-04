#!/usr/bin/env bash
set -e

echo "calling elasticsearch _cluster/health endpoint"
health=$(curl -X GET --silent -k -u "elastic:elastic" "https://localhost:9200/_cluster/health")

echo -n "TEST if elasticsearch cluster state is green..."
status=$(jq -r .status <<<"${health}")
if [ "${status,,}" != "green" ]; then
  echo "failed: cluster state is ${status}"
  exit 1
fi
echo "OK"

echo -n "TEST if elasticsearch cluster has 2 nodes..."
number_of_nodes=$(jq -r .number_of_nodes <<<"${health}")
if [ "${number_of_nodes,,}" != "2" ]; then
  echo "failed: number_of_nodes is ${number_of_nodes}"
  exit 1
fi
number_of_data_nodes=$(jq -r .number_of_data_nodes <<<"${health}")
if [ "${number_of_data_nodes,,}" != "2" ]; then
  echo "failed: number_of_data_nodes is ${number_of_data_nodes}"
  exit 1
fi
echo "OK"
