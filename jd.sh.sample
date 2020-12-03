#!/usr/bin/env bash

## Author: Evine Deng
## Source: https://github.com/EvineDeng/jd-base
## Modified： 2020-12-03
## Version： v2.3.8

# export JD_BEAN_SIGN_STOP_NOTIFY=
# export JD_BEAN_SIGN_NOTIFY_SIMPLE=
# export JD_USER_AGENT=

RootDir=$(cd $(dirname $0); cd ..; pwd)
ScriptsDir=${RootDir}/scripts
LogDir=${RootDir}/log
FileName=$(echo $(basename $0) | perl -pe "s|\..*sh||")
LogTime=$(date "+%Y-%m-%d-%H-%M-%S")
LogFile="${LogDir}/${FileName}/${LogTime}.log"

[ ! -d ${LogDir}/${FileName} ] && mkdir -p ${LogDir}/${FileName}
cd ${ScriptsDir} && node ${FileName}.js > ${LogFile}
