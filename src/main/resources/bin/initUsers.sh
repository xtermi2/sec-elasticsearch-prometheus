#!/usr/bin/env bash
#
# This scrip will configure elasticsearch users/passwords
#

/usr/local/bin/wait_until_started.sh

/usr/local/bin/configureUsers.sh
