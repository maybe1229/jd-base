#!/bin/sh
set -e

RootDir="/root"
ShellDir="${RootDir}/shell"
LogDir="${RootDir}/log"
ScriptsDir="${RootDir}/scripts"


if [ ! -d ${LogDir} ]; then
  echo "检测到日志目录不存在，现在创建..."
  echo
  mkdir ${LogDir}
fi


echo "启动crond定时任务守护程序，日志文件重定向至/root/log/crond.log..."
echo
crond -L /root/log/crond.log


if [ -s ${RootDir}/crontab.list ] && [ -d ${ShellDir} ] && [ -d ${ScriptsDir} ]
then
  echo "发现映射目录/root下存在crontab.list文件，现从该文件自动恢复定时任务..."
  echo
  crontab ${RootDir}/crontab.list
  echo "自动恢复定时任务如下："
  echo
  crontab -l
  echo  
else
  echo "${ShellDir}不存在或${ScriptsDir}不存在或${RootDir}/crontab.list不存在..."
  echo
  echo "可能是首次启动容器，跳过恢复定时任务..."
  echo
  echo "请后续进入容器并做好配置后，再使用 crontab ${RootDir}/crontab.list 添加..."
  echo
fi

if [ ! -d ${ScriptsDir} ]
then
  echo "检测到JS脚本目录不存在，自动克隆..."
  echo
  cd ${RootDir}
  git clone https://github.com/lxk0301/scripts
  echo
else
  echo "js脚本已克隆好，跳过..."
  echo
fi





if [ ! d ${ShellDir} ]
then
  echo "检测到shell脚本目录不存在，自动克隆..."
  echo
  cd ${RootDir}
  git clone https://github.com/EvineDeng/jd-base shell
  echo
  if [ -d ${ScriptsDir}/.github/workflows ]; then
    List=$(ls ${ScriptsDir}/.github/workflows | sed "s|\.yml||" | sed "/sync/d")
	
    if [ $List ]
    then
      for i in $List; do
        if [ ! -d ${LogDir}/$i ]
        then
          echo "创建 ${LogDir}/$i"
		  echo
          mkdir ${LogDir}/$i
        else 
          echo "${LogDir}/$i 已存在，跳过创建..."
		  echo
        fi
    
        if [ -s ${ShellDir}/jd.sample.sh ]
        then
          cp -fv ${ShellDir}/jd.sample.sh ${ShellDir}/$i.sh
		  echo
        else
          echo "${ShellDir}/$i.sh不存在，可能没有正确克隆shell脚本..."
		  echo
        fi
      done
    else
      echo "JS脚本似乎获取不正常，请删除容器并重新运行..."
	  echo
	fi
  fi
else
  echo "检测到shell脚本目录已存在，跳过..."
  echo
fi

if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ]; then
  set -- node "$@"
fi

exec "$@"
