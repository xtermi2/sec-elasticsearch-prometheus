#!/usr/bin/env bash
set -e

echo "calling elasticsearch _prometheus/metrics endpoint"
metrics=$(curl -X GET --silent -k -u "remote_monitoring_user:monitor" "https://localhost:9200/_prometheus/metrics")

echo -n "TEST if elasticsearch prometheus metrics contain es_os_mem_used_percent..."
if [[ "$metrics" =~ es_os_mem_used_percent\{cluster=\"my-cluster ]]; then
  echo "OK"
else
  echo "failed!"
  exit 1
fi

echo -n "TEST if elasticsearch prometheus metrics contain es_cluster_shards_active_percent..."
if [[ "$metrics" =~ es_cluster_shards_active_percent\{cluster=\"my-cluster ]]; then
  echo "OK"
else
  echo "failed!"
  exit 1
fi
