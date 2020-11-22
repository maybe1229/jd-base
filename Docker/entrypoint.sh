#!/bin/bash
set -e

if [ ! -d /root/log ]; then
  mkdir -p /root/log
fi

crond -L /root/log/crond.log

if [ ! -f /root/first_run.sh ]
then
  cp -f /first_run.sh /root/first_run.sh
  chmod 777 /root/first_run.sh
else
  FirstRunOld=$(cat /root/first_run.sh)
  FirstRunNew=$(cat /first_run.sh)
  if [ "${FirstRunOld}" != "${FirstRunNew}" ]; then
    cp -f /first_run.sh /root/first_run.sh
    chmod 777 /root/first_run.sh
  fi
fi

cd /root

if [ ! -d /root/scripts ] || [ ! -d /root/shell ] || [ ! -d /root/log ] || [ -f /root/crontab.list ]; then
  bash first_run.sh
fi

if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ]; then
  set -- node "$@"
fi

exec "$@"
