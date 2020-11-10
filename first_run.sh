#!/bin/sh

## 修改日期：2020-10-17
## 作者：Evine Deng <evinedeng@foxmail.com>

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export LC_ALL=C


RootDir=$(cd $(dirname $0); pwd)
ShellDir="${RootDir}/shell"
LogDir="${RootDir}/log"
ScriptsDir="${RootDir}/scripts"
List=

isDocker=$(cat /proc/1/cgroup | grep docker)

cd ${RootDir}

if [ -d ${ScriptsDir} ] && [ -d ${ShellDir} ] && [ -f ${RootDir}/crontab.list ] && [ -n "${isDocker}" ]; then
  echo -e "检测到本机为容器，并且${ScriptsDir}、${ShellDir}、${RootDir}/crontab.list均存在，开始自动恢复定时任务...\n"
  crontab ${RootDir}/crontab.list
  echo -e "当前的定时任务如下：\n"
  crontab -l
  echo ""
fi

if [ ! -d ${ScriptsDir} ]; then
  echo -e "${ScriptsDir} 目录不存在，开始克隆...\n"
  git clone https://github.com/lxk0301/jd_scripts scripts
  echo
fi

if [ ! -d ${ShellDir} ]; then
  echo -e "${ShellDir} 目录不存在，开始克隆...\n"
  git clone https://github.com/EvineDeng/jd-base shell
  echo
fi

## 因js主库调整，临时解决办法，未来有时间再改
List="jd_bean_change jd_bean_sign jd_blueCoin jd_collectProduceScore jd_daily_egg jd_club_lottery jd_fruit jd_joy jd_joy_feedPets jd_joy_reward jd_joy_steal jd_lotteryMachine jd_moneyTree jd_pet jd_pigPet jd_plantBean jd_rankingList jd_redPacket jd_shop jd_speed jd_superMarket jd_818 jd_xtg jd_unsubscribe"


if [ -n "$List" ]
then
  for i in $List; do
    if [ ! -d ${LogDir}/$i ]
    then
      echo "创建 ${LogDir}/$i 目录..."
      echo
      mkdir -p ${LogDir}/$i
    else 
      echo "目录 ${LogDir}/$i 已存在，跳过创建..."
      echo
    fi
  done
else
  echo "js脚本获取不正常，请手动克隆..."
fi


if [ -s ${ShellDir}/jd.sh.sample ]
then
  if [ -n "$List" ]; then
    for i in $List; do
      cp -fv "${ShellDir}/jd.sh.sample" "${ShellDir}/$i.sh"
      chmod +x "${ShellDir}/$i.sh"
      echo
    done
  fi
else
  echo "脚本 $${ShellDir}/jd.sh.sample 文件不存在或内容为空，可能shell脚本克隆不正常，请手动克隆..."
  echo
fi

