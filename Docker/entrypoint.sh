#!/bin/bash
set -e

[ ! -d /root/log ] && mkdir -p /root/log
crond -L /root/log/crond.log

if [ ! -f /root/first_run.sh ] || [[ "$(cat /root/first_run.sh)" != "$(cat /first_run.sh)" ]]; then
  cp -f /first_run.sh /root/first_run.sh
  chmod 777 /root/first_run.sh
fi

cd /root

if [ ! -d /root/scripts ] || [ ! -d /root/shell ] || [ ! -d /root/log ] || [ -f /root/crontab.list ]; then
  bash first_run.sh
fi

if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ]; then
  set -- node "$@"
fi

exec "$@"
