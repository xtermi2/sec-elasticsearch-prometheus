#!/usr/bin/env bash

general_status=0

echo -n "TEST if filebeats status endpoint reports some published events..."
RET=1
count=0
filebeat_stats=""
filebeats_status_events_done=0
while ((filebeats_status_events_done < 1 && count < 20)); do
  sleep 1
  filebeat_stats=$(curl -X GET --silent -f "http://localhost:5066/stats")
  RET=$?
  filebeats_status_events_done=$(jq -r .filebeat.events.done <<<"${filebeat_stats}")
  echo -n "."
  ((count++))
done
if ((RET != 0)); then
  echo "failed! result=\"${filebeat_stats}\""
  ((general_status++))
else
  echo "OK - filebeat.events.done: ${filebeats_status_events_done}"
fi

echo -n "calling elasticsearch filebeat-* endpoint..."
index=""
count=0
while [[ "${index}" == "" && $count -lt 30 ]]; do
  sleep 1
  index=$(curl -X GET --silent -k -u 'kibana_user:kibana' 'https://localhost:9200/filebeat-*?pretty')
  echo -n "."
  ((count++))
done
echo ""

echo -n "TEST if filebeat index exists..."
meta_beat=$(jq -r '.[].mappings._meta.version' <<<"${index}")
if [ "${meta_beat}" != "7.14.0" ]; then
  echo "failed: mappings._meta.version is unexpected \"${meta_beat}\"; response=\"${index}\""
  echo "filebeat_stats: ${filebeat_stats}"
  ((general_status++))
else
  echo "OK"
fi

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
  echo "filebeat_stats: ${filebeat_stats}"
  ((general_status++))
else
  echo "OK - count: ${count}"
fi

exit ${general_status}
