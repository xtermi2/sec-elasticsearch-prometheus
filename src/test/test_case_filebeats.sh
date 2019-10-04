#!/usr/bin/env bash

echo "calling elasticsearch filebeat-* endpoint"
index=$(curl -X GET --silent -k -u "kibana_user:kibana" "https://localhost:9200/filebeat-*?pretty")

echo -n "TEST if filebeat index exists..."
meta_beat=$(jq -r '.[].mappings._meta.beat' <<<"${index}")
if [ "${meta_beat,,}" != "filebeat" ]; then
  echo "failed: mappings._meta.beat is unexpected \"${meta_beat}\"; response=\"${index}\""
  exit 1
fi
echo "OK"

index_name=$(jq -r 'keys[]' <<<"${index}")
echo -n "TEST document count in index \"${index_name}\"..."
count=0
itterations=0
while ((count < 1 && itterations < 20)); do
  sleep 1
  count=$(curl -X GET --silent -k -u "kibana_user:kibana" "https://localhost:9200/${index_name}/_count" | jq -r .count)
  ((itterations++))
done
if ((count < 1)); then
  echo "failed: count is \"${count}\""
  exit 1
fi
echo "OK"
