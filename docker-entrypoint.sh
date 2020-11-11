#!/bin/sh

## 修改日期：2020-10-17
## 作者：Evine Deng <evinedeng@foxmail.com>

set -e

if [ ! -d /root/log ]; then
  mkdir -p /root/log
fi

crond -L /root/log/crond.log

URLFirstRun="https://raw.githubusercontent.com/EvineDeng/jd-base/main/first_run.sh"

cd /root
sh -c "$(wget ${URLFirstRun} -O -)"
if [ $? -ne 0 ]
then
  sh -c "$(curl -fsSL ${URLFirstRun})"
fi


if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ]; then
  set -- node "$@"
fi

exec "$@"
