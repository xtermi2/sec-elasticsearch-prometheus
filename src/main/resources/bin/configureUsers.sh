#!/usr/bin/env bash

function passwd() {
  if [ -z "${2}" ]; then
    echo "no password defined for user \"${1}\" ... skipping!"
  else
    RET=1
    while [[ RET -ne 0 ]]; do
      echo "set password for user \"${1}\""

      curl -X POST --silent -k -u "elastic:${ELASTIC_PASSWORD}" "https://localhost:9200/_security/user/${1}/_password" \
        -H "Content-Type: application/json" \
        -d "{\"password\" : \"${2}\"}"
      RET=$?
      echo "set password for user \"${1}\" returned status=${RET}"
      if [[ RET -ne 0 ]]; then
        echo "retry after 5 seconds..."
        sleep 5
      fi
    done
  fi
}

function addUser() {
  if [ -z "${3}" ]; then
    echo "no password defined for user \"${1}\" ... skipping!"
  else
    RET=1
    while [[ RET -ne 0 ]]; do
      echo "add user \"${1}\" with roles [ ${2} ]"

      curl -X POST --silent -k -u "elastic:${ELASTIC_PASSWORD}" "https://localhost:9200/_security/user/${1}" \
        -H "Content-Type: application/json" \
        -d "{\"password\" : \"${3}\", \"roles\" : [ ${2} ]}"
      RET=$?
      echo "add user \"${1}\" with roles [ ${2} ] returned status=${RET}"
      if [[ RET -ne 0 ]]; then
        echo "retry after 5 seconds..."
        sleep 5
      fi
    done
  fi
}

function listUsers() {
  curl -X GET --silent -k -u "elastic:${ELASTIC_PASSWORD}" "https://localhost:9200/_security/user?pretty"
}

echo "list initial existing users with their roles:"
listUsers

echo "set passwords for pre defined users from environment variables"
passwd kibana "${KIBANA_PASSWORD}"
passwd beats_system "${BEATS_PASSWORD}"
passwd logstash_system "${LOGSTASH_PASSWORD}"
passwd apm_system "${APM_PASSWORD}"
passwd remote_monitoring_user "${REMOTE_MONITORING_PASSWORD}"

# existing default roles: [kibana_dashboard_only_user, apm_system, watcher_admin, logstash_system, rollup_user, kibana_user, beats_admin, remote_monitoring_agent, rollup_admin, code_user, data_frame_transforms_admin, snapshot_user, monitoring_user, logstash_admin, machine_learning_user, data_frame_transforms_user, machine_learning_admin, watcher_user, apm_user, beats_system, reporting_user, kibana_system, transport_client, remote_monitoring_collector, code_admin, superuser, ingest_admin]
# https://www.elastic.co/guide/en/elastic-stack-overview/current/built-in-roles.html
addUser "beats" "\"beats_system\", \"beats_admin\", \"filebeats_admin\"" "${BEATS_PASSWORD}"
addUser "kibana_user" "\"kibana_administrator\", \"kibana_admin\", \"reporting_user\"" "${KIBANA_USER_PASSWORD}"

echo "list existing users with their roles after modifications are done:"
listUsers
