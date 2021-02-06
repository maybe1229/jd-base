#!/usr/bin/env bash

## Author: Evine Deng
## Source: https://github.com/EvineDeng/jd-base
## Modified： 2020-12-03
## Version： v2.3.8

RootDir=$(cd $(dirname $0); pwd)
ShellDir="${RootDir}/shell"
LogDir="${RootDir}/log"
ScriptsDir="${RootDir}/scripts"
isDocker=$(cat /proc/1/cgroup | grep docker)

## 尝试自动恢复任务，如文件夹不存在则尝试克隆
function Detect_Cron {
  if [ -d ${ScriptsDir} ] && [ -d ${ShellDir} ] && [ -f ${RootDir}/crontab.list ] && [ -n "${isDocker}" ]
  then
    echo -e "\n检测到本机为容器，并且${ScriptsDir}、${ShellDir}、${RootDir}/crontab.list均存在，开始自动恢复定时任务...\n"
    crontab ${RootDir}/crontab.list
    echo -e "当前的定时任务如下：\n"
    crontab -l
    echo -e "\n成功恢复定时任务...\n"
  elif [ -d ${ScriptsDir} ] && [ -d ${ShellDir} ] && [ -f ${RootDir}/crontab.list ] && [ -z "${isDocker}" ]
  then
    echo -e "\n检测到本机为物理机，虽然${ScriptsDir}、${ShellDir}、${RootDir}/crontab.list均存在...\n但为防止破坏物理机上本身已经存在的定时任务，跳过恢复定时任务，请手动添加...\n"
    echo -e "3...\n"
    sleep 1
    echo -e "2...\n"
    sleep 1
    echo -e "1...\n"
    sleep 1
  else
    if [ ! -d ${ScriptsDir} ]
    then
      echo -e "\n${ScriptsDir} 目录不存在，开始克隆...\n"
      git clone -b master https://github.com/lxk0301/jd_scripts ${ScriptsDir}
    else
      echo -e "\n${ScriptsDir} 目录已存在，跳过克隆...\n"
    fi
  
    if [ ! -d ${ShellDir} ]
    then
      echo -e "\n${ShellDir} 目录不存在，开始克隆...\n"
      git clone -b main https://github.com/EvineDeng/jd-base ${ShellDir}
    else
      echo -e "\n${ShellDir} 目录已存在，跳过克隆...\n"
    fi
  fi
}

## 判断主机是不是Docker容器，如果不是，等待1秒
function Detect_Docker {
  if [ -z "${isDocker}" ]; then
    sleep 1
  fi
}

## 创建初始日志目录
function Make_LogDir {
  ## 读取 ${ShellDir}/crontab.list.sample 中定时任务为初始任务清单
  if [ -f ${ShellDir}/crontab.list.sample ]; then
    JsList=$(cat ${ShellDir}/crontab.list.sample | grep -E "jd_.+\.sh" | perl -pe "s|.+(jd_.+)\.sh.*|\1|" | sort -u)
  fi
  
  if [ -n "${JsList}" ]
  then
    for Task in ${JsList}; do
      if [ ! -d ${LogDir}/${Task} ]
      then
        echo -e "\n创建 ${LogDir}/${Task} 日志目录..."
        mkdir -p ${LogDir}/${Task}
        Detect_Docker
      else 
        echo -e "\n日志目录 ${LogDir}/${Task} 已存在，跳过创建..."
        Detect_Docker
      fi
    done
  else
    if [ -z "${isDocker}" ]
    then
      echo -e "\n${ShellDir}/crontab.list.sample 不存在，可能是 shell 脚本克隆不正常，请删除 ${ShellDir} 文件夹后重新运行本脚本..."
    else
      echo -e "\n${ShellDir}/crontab.list.sample 不存在，可能是 shell 脚本克隆不正常，请删除 ${ShellDir} 文件夹后重新启动容器..."
    fi
  fi
}

## 复制初始任务脚本子函数
function Copy_ShellSub {
  cp -fv "${ShellDir}/jd.sh.sample" "${ShellDir}/${Task}.sh"
  chmod +x "${ShellDir}/${Task}.sh"
  echo
  Detect_Docker
}

## 复制初始任务脚本
function Copy_Shell {
  if [ -s ${ShellDir}/jd.sh.sample ] && [ -n "${JsList}" ]
  then
    echo
    VerSample=$(cat ${ShellDir}/jd.sh.sample | grep -i "Version" | perl -pe "s|.+v((\d+\.?){3})|\1|")
    for Task in ${JsList}; do
      if [ -f ${ShellDir}/${Task}.sh ]
      then
        VerJdShell=$(cat ${ShellDir}/${Task}.sh | grep -i "Version" | perl -pe "s|.+v((\d+\.?){3})|\1|")
        if [ "${VerSample}" != "${VerJdShell}" ]; then
          Copy_ShellSub
        fi
      else
        Copy_ShellSub
      fi
    done
    echo -e "脚本执行成功，请按照教程继续配置...\n"
  elif [ ! -s ${ShellDir}/jd.sh.sample ] && [ -z "${isDocker}" ]
  then
    echo -e "\n${ShellDir}/jd.sh.sample 不存在或内容为空，可能是 shell 脚本克隆不正常，请删除 ${ShellDir} 文件夹后重新运行本脚本...\n"
  elif [ ! -s ${ShellDir}/jd.sh.sample ] && [ -n "${isDocker}" ]
  then
    echo -e "\n${ShellDir}/jd.sh.sample 不存在或内容为空，可能是 shell 脚本克隆不正常，请删除 ${ShellDir} 文件夹后重新启动容器...\n"
  fi
}

cd ${RootDir} && Detect_Cron && Make_LogDir && Copy_Shell
