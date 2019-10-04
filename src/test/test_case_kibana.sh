#!/usr/bin/env bash

general_status=0

echo -n "TEST if kibana status endpoint is returning HTTP 200..."
RET=1
count=0
while ((RET != 0 && count < 60)); do
  sleep 1
  curl -X GET --silent -f "http://localhost:5601/status" >/dev/null 2>&1
  RET=$?
  echo -n "."
  ((count++))
done
if ((RET != 0)); then
  echo "failed!"
  ((general_status++))
else
  echo "OK"
fi

echo "calling kibana api/status endpoint"
api_status=$(curl -X GET --silent -k -f -u "kibana_user:kibana" "http://localhost:5601/api/status")

echo -n "TEST if kibana overall state is green..."
overall_status=$(jq -r .status.overall.state <<<"${api_status}")
if [ "${overall_status,,}" != "green" ]; then
  echo "failed: overall state is ${overall_status}"
  ((general_status++))
else
  echo "OK"
fi

exit ${general_status}
