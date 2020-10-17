#!/bin/sh

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export LC_ALL=C


RootDir="/root"
ShellDir=${RootDir}/shell
LogDir=${RootDir}/log
ScriptsDir=${RootDir}/scripts
List=


if [ ! -d ${ScriptsDir} ]
then
  echo "${ScriptsDir} 目录不存在，开始克隆..."
  echo
  cd ${RootDir}
  git clone https://github.com/lxk0301/scripts
  echo
else
  echo "${ScriptsDir} 目录已存在，跳过克隆..."
  echo
fi


if [ ! d ${ShellDir} ]
then
  echo "${ShellDir} 不存在，开始克隆..."
  echo
  cd ${RootDir}
  git clone https://github.com/EvineDeng/jd-base shell
  echo
else
  echo "${ShellDir} 已存在，跳过克隆..."
  echo
fi


if [ -d ${ScriptsDir}/.github/workflows ]; then
  List=$(ls ${ScriptsDir}/.github/workflows | sed "s|\.yml||" | sed "/sync/d")
  echo "js脚本清单如下："
  echo
  echo $List
  echo
fi


if [ ! -d ${LogDir} ]; then
  mkdir -p ${LogDir}
fi


if [ $List ]
then
  for i in $List; do
    if [ ! -d ${LogDir}/$i ]
    then
      echo "创建 ${LogDir}/$i ..."
	  echo
      mkdir log/$i
    else 
      echo "目录 ${LogDir}/$i 已存在，跳过创建..."
	  echo
    fi
    
    if [ -s ${ScriptsDir}/jd.sample.sh ]
    then
      echo "创建 ${ScriptsDir}/$i.sh"
      cp -f "${ScriptsDir}/jd.sample.sh" "${ScriptsDir}/$i.sh"
	  echo
    else
      echo "${ScriptsDir}/jd.sample.sh 不存在，可能shell脚本克隆不正常，请手动克隆..."
	  echo
    fi
  done
else
  echo "js脚本获取不正常，请手动克隆..."
fi
