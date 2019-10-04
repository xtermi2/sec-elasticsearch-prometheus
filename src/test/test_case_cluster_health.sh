#!/usr/bin/env bash

general_status=0

echo "calling elasticsearch _cluster/health endpoint"
health=$(curl -X GET --silent -k -u "elastic:elastic" "https://localhost:9200/_cluster/health")

echo -n "TEST if elasticsearch cluster state is green..."
status=$(jq -r .status <<<"${health}")
if [ "${status,,}" != "green" ]; then
  echo "failed: cluster state is ${status}"
  ((general_status++))
else
  echo "OK"
fi

echo -n "TEST if elasticsearch cluster has 2 nodes..."
number_of_nodes=$(jq -r .number_of_nodes <<<"${health}")
if [ "${number_of_nodes,,}" != "2" ]; then
  echo "failed: number_of_nodes is ${number_of_nodes}"
  ((general_status++))
else
  echo "OK"
fi
number_of_data_nodes=$(jq -r .number_of_data_nodes <<<"${health}")
if [ "${number_of_data_nodes,,}" != "2" ]; then
  echo "failed: number_of_data_nodes is ${number_of_data_nodes}"
  ((general_status++))
else
  echo "OK"
fi

exit ${general_status}
