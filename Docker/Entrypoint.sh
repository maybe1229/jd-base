#!/bin/bash
set -e

if [ ! -d /root/log ]; then
  mkdir -p /root/log
fi

crond -L /root/log/crond.log

URLFirstRun="https://raw.githubusercontent.com/EvineDeng/jd-base/main/first_run.sh"

cd /root
bash -c "$(wget ${URLFirstRun} -O -)" || bash -c "$(curl -fsSL ${URLFirstRun})"


if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ]; then
  set -- node "$@"
fi

exec "$@"
