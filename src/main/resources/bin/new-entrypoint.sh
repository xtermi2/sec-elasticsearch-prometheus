#!/usr/bin/env bash
# this is the docker entrypoint.

echo "run init in background. Script waits until elasticsearch is up and running and then configures the users/passwords"
/usr/local/bin/initUsers.sh &

echo "start elasticsearch"
/usr/local/bin/docker-entrypoint.sh "$@"
