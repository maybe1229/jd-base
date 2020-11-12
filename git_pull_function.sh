#!/bin/sh

## 修改日期：2020-11-10
## 作者：Evine Deng <evinedeng@foxmail.com>

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export LC_ALL=C


################################## 定义文件路径（勿动） ##################################
RootDir=$(cd $(dirname $0); cd ..; pwd)
LogDir=${RootDir}/log
ScriptsDir=${RootDir}/scripts
ScriptsURL=https://github.com/lxk0301/jd_scripts
ShellURL=https://github.com/EvineDeng/jd-base
ListShell=${LogDir}/shell.list
ListJs=${LogDir}/js.list
ListJsAdd=${LogDir}/js-add.list
ListJsDrop=${LogDir}/js-drop.list
ListCron=${RootDir}/crontab.list


################################## 定义js脚本名称 ##################################
FileCookie=jdCookie.js
FileNotify=sendNotify.js
FileFruitShareCodes=jdFruitShareCodes.js
FilePetShareCodes=jdPetShareCodes.js
FilePlantBeanShareCodes=jdPlantBeanShareCodes.js
FileSuperMarketShareCodes=jdSuperMarketShareCodes.js
FileJoy=jd_joy.js
FileJoyFeed=jd_joy_feedPets.js
FileJoyReward=jd_joy_reward.js
FileJoySteal=jd_joy_steal.js
FileBlueCoin=jd_blueCoin.js
FileSuperMarket=jd_superMarket.js
FileFruit=jd_fruit.js
FilePet=jd_pet.js
File818=jd_818.js
FileUnsubscribe=jd_unsubscribe.js


################################## 在日志中记录时间与路径 ##################################
echo -e "\n-------------------------------------------------------------------\n"
echo -n "系统时间："
echo $(date "+%Y-%m-%d %H:%M:%S")
if [ "${TZ}" = "UTC" ]; then
  echo
  echo -n "北京时间："
  echo $(date -d "8 hour" "+%Y-%m-%d %H:%M:%S")
fi
echo -e "\nSHELL脚本目录：${ShellDir}\n"
echo -e "JS脚本目录：${ScriptsDir}\n"
echo -e "-------------------------------------------------------------------\n"


################################## 判断是否输入用户数量 ##################################
function Detect_UserSum {
  if [ -z "${UserSum}" ]; then
    echo -e "请输入有效的用户数量(UserSum)...\n"
    exit 1
  fi
}


################################## 更新JS脚本 ##################################
function Git_PullScripts {
  echo -e "更新JS脚本，原地址：${ScriptsURL}\n"
  git fetch --all
  git reset --hard origin/master
  git pull
  echo
}


################################## 修改JS脚本中的Cookie ##################################
function Change_Cookie {
  CookieALL=""
  echo -e "${FileCookie}: 替换Cookies...\n"
  sed -i "/\/\/账号/d" ${FileCookie}
  ii=1
  while [ ${ii} -le ${UserSum} ]
  do
    Temp1=Cookie${ii}
    eval CookieTemp=$(echo \$${Temp1})
    CookieALL="${CookieALL}\\n'${CookieTemp}',"
    let ii++
  done
  perl -0777 -i -pe "s|let CookieJDs = \[\n\]|let CookieJDs = \[${CookieALL}\n\]|" ${FileCookie}
}


################################## 修改通知TOKEN ##################################
function Change_Token {
  ## ServerChan
  if [ ${SCKEY} ]; then
    echo -e "${FileNotify}: 替换ServerChan推送通知SCKEY...\n"
    sed -i "s|let SCKEY = '';|let SCKEY = '${SCKEY}';|" ${FileNotify}
  fi

  ## BARK
  if [ ${BARK_PUSH} ] && [ ${BARK_SOUND} ]; then
    echo -e "${FileNotify}: 替换BARK推送通知BARK_PUSH、BARK_SOUND...\n"
    sed -i "s|let BARK_PUSH = '';|let BARK_PUSH = '${BARK_PUSH}';|" ${FileNotify}
    sed -i "s|let BARK_SOUND = '';|let BARK_SOUND = '${BARK_SOUND}';|" ${FileNotify}
  fi

  ## Telegram
  if [ ${TG_BOT_TOKEN} ] && [ ${TG_USER_ID} ]; then
    echo -e "${FileNotify}: 替换Telegram推送通知TG_BOT_TOKEN、TG_USER_ID...\n"
    sed -i "s|let TG_BOT_TOKEN = '';|let TG_BOT_TOKEN = '${TG_BOT_TOKEN}';|" ${FileNotify}
    sed -i "s|let TG_USER_ID = '';|let TG_USER_ID = '${TG_USER_ID}';|" ${FileNotify}
  fi

  ## 钉钉
  if [ ${DD_BOT_TOKEN} ]; then
    echo -e "${FileNotify}: 替换钉钉推送通知DD_BOT...\n"
    sed -i "s|let DD_BOT_TOKEN = '';|let DD_BOT_TOKEN = '${DD_BOT_TOKEN}';|" ${FileNotify}
    if [ ${DD_BOT_SECRET} ]; then
      sed -i "s|let DD_BOT_SECRET = '';|let DD_BOT_SECRET = '${DD_BOT_SECRET}';|" ${FileNotify}
    fi
  fi

  ## iGot
  if [ ${IGOT_PUSH_KEY} ]; then
    echo -e "${FileNotify}: 替换iGot推送KEY...\n"
    sed -i "s|let IGOT_PUSH_KEY = '';|let IGOT_PUSH_KEY = '${IGOT_PUSH_KEY}';|" ${FileNotify}
  fi
  
  ## 未输入任何通知渠道
  if [ -z "${SCKEY}" ] && [ -z "${BARK_PUSH}" ] && [ -z "${BARK_SOUND}" ] && [ -z "${TG_BOT_TOKEN}" ] && [ -z "${TG_USER_ID}" ] && [ -z "${DD_BOT_TOKEN}" ] && [ -z "${DD_BOT_SECRET}" ] && [ -z "${IGOT_PUSH_KEY}" ]; then
    echo -e "没有有效的通知渠道，将不发送任何通知，请直接在本地查看日志...\n"
  fi
}


################################## 替换东东农场互助码 ##################################
function Change_FruitShareCodes {
  ForOtherFruitALL=""
  echo -e "${FileFruitShareCodes}: 替换东东农场互助码...\n"
  sed -i "/\/\/账号/d" ${FileFruitShareCodes}
  ij=1
  while [ ${ij} -le ${UserSum} ]
  do
    Temp2=ForOtherFruit${ij}
    eval ForOtherFruitTemp=$(echo \$${Temp2})
    ForOtherFruitALL="${ForOtherFruitALL}\\n'${ForOtherFruitTemp}',"
    let ij++
  done
  perl -0777 -i -pe "s|let FruitShareCodes = \[\n\]|let FruitShareCodes = \[${ForOtherFruitALL}\n\]|" ${FileFruitShareCodes}
}


################################## 替换东东萌宠互助码 ##################################
function Change_PetShareCodes {
  ForOtherPetALL=""
  echo -e "${FilePetShareCodes}: 替换东东萌宠互助码...\n"
  sed -i "/\/\/账号/d" ${FilePetShareCodes}
  ik=1
  while [ ${ik} -le ${UserSum} ]
  do
    Temp3=ForOtherPet${ik}
    eval ForOtherPetTemp=$(echo \$${Temp3})
    ForOtherPetALL="${ForOtherPetALL}\\n'${ForOtherPetTemp}',"
    let ik++
  done
  perl -0777 -i -pe "s|let PetShareCodes = \[\n\]|let PetShareCodes = \[${ForOtherPetALL}\n\]|" ${FilePetShareCodes}
}


################################## 替换种豆得豆互助码 ##################################
function Change_PlantBeanShareCodes {
  ForOtherPlantBeanALL=""
  echo -e "${FilePlantBeanShareCodes}: 替换种豆得豆互助码...\n"
  sed -i "/\/\/账号/d" ${FilePlantBeanShareCodes}
  il=1
  while [ ${il} -le ${UserSum} ]
  do
    Temp4=ForOtherPlantBean${il}
    eval ForOtherPlantBeanTemp=$(echo \$${Temp4})
    ForOtherPlantBeanALL="${ForOtherPlantBeanALL}\\n'${ForOtherPlantBeanTemp}',"
    let il++
  done
  perl -0777 -i -pe "s|let PlantBeanShareCodes = \[\n\]|let PlantBeanShareCodes = \[${ForOtherPlantBeanALL}\n\]|" ${FilePlantBeanShareCodes}
}


################################## 替换东东超市商圈互助码 ##################################
# function Change_SuperMarketShareCodes {
#   ForOtherSuperMarketALL=""
#   echo -e "${FileSuperMarketShareCodes}: 替换东东超市商圈互助码...\n"
#   sed -i "/\/\/账号/d" ${FileSuperMarketShareCodes}
#   im=1
#   while [ ${im} -le ${UserSum} ]
#   do
#     Temp5=ForOtherSuperMarket${im}
#     eval ForOtherSuperMarketTemp=$(echo \$${Temp5})
#     ForOtherSuperMarketALL="${ForOtherSuperMarketALL}\\n'${ForOtherSuperMarketTemp}',"
#     let im++
#   done
#   perl -0777 -i -pe "s|let SuperMarketShareCodes = \[\n\]|let SuperMarketShareCodes = \[${ForOtherSuperMarketALL}\n\]|" ${FileSuperMarketShareCodes}
# }


################################## 修改东东超市蓝币兑换数量 ##################################
function Change_coinToBeans {
  expr ${coinToBeans} "+" 10 &>/dev/null
  if [ $? -eq 0 ]
  then
    case ${coinToBeans} in 
      [1-9] | 1[0-9] | 20 | 1000)
        echo -e "${FileBlueCoin}: 修改东东超市蓝币兑换 ${coinToBeans} 个京豆...\n"
        perl -i -pe "s|let coinToBeans = .+;|let coinToBeans = ${coinToBeans};|" ${FileBlueCoin};;
      0)
        echo -e "${FileBlueCoin}: 东东超市不自动兑换蓝币，保持默认...\n";;
      *)
        echo -e "${FileBlueCoin}: coinToBeans输入了错误的数字，东东超市不自动兑换蓝币，保持默认...\n";;
    esac
  else
    echo -e "${FileBlueCoin}: 修改东东超市蓝币兑换实物奖品：${coinToBeans}，该奖品是否可兑换以js运行日志为准...\n"
    perl -i -pe "s|let coinToBeans = .+;|let coinToBeans = \'${coinToBeans}\';|" ${FileBlueCoin}
  fi
}


################################## 修改东东超市蓝币成功兑换奖品是否静默运行 ##################################
function Change_NotifyBlueCoin {
  if [ "${NotifyBlueCoin}" = "true" ]
  then
    echo -e "${FileBlueCoin}：修改东东超市成功兑换蓝币是否静默运行：${NotifyBlueCoin}，成功兑换后静默运行不发通知...\n"
    sed -i "s|let jdNotify = false;|let jdNotify = ${NotifyBlueCoin};|" ${FileBlueCoin}
  else
    echo -e "${FileBlueCoin}：NotifyBlueCoin保持默认，东东超市成功兑换蓝币后将发通知...\n"
  fi
}


################################## 修改东东超市是否自动升级商品和货架 ##################################
function Change_superMarketUpgrade {
  if [ "${superMarketUpgrade}" = "false" ]
  then
    echo -e "${FileSuperMarket}：修改东东超市是否自动升级商品和货架为：${superMarketUpgrade}，不自动升级...\n"
    sed -i "s|let superMarketUpgrade = true;|let superMarketUpgrade = ${superMarketUpgrade};|" ${FileSuperMarket}
  else
    echo -e "${FileSuperMarket}：superMarketUpgrade保持默认，东东超市将默认自动升级商品和货架...\n"
  fi
}


################################## 修改东东超市是否自动更换商圈 ##################################
function Change_businessCircleJump {
  if [ "${businessCircleJump}" = "false" ]
  then
    echo -e "${FileSuperMarket}：修改东东超市在小于对方300热力值时是否自动更换商圈为：${businessCircleJump}\n"
    sed -i "s|let businessCircleJump = true;|let businessCircleJump = ${businessCircleJump};|" ${FileSuperMarket}
  else
    echo -e "${FileSuperMarket}：businessCircleJump保持默认，东东超市将在小于对方300热力值时自动更换商圈...\n"
  fi
}


################################## 修改东东超市是否自动使用金币去抽奖 ##################################
function Change_drawLotteryFlag {
  if [ "${drawLotteryFlag}" = "true" ]
  then
    echo -e "${FileSuperMarket}：修改东东超市是否自动使用金币去抽奖为：${drawLotteryFlag}，自动使用金币去抽奖...\n"
    sed -i "s|let drawLotteryFlag = false;|let drawLotteryFlag = ${drawLotteryFlag};|" ${FileSuperMarket}
  else
    echo -e "${FileSuperMarket}：drawLotteryFlag保持默认，东东超市将不去抽奖...\n"
  fi
}


################################## 修改东东农场是否静默运行 ##################################
function Change_NotifyFruit {
  if [ "${NotifyFruit}" = "true" ]
  then
    echo -e "${FileFruit}：修改东东农场是否静默运行为：${NotifyFruit}，静默运行，不发通知...\n"
    sed -i "s|let jdNotify = false;|let jdNotify = ${NotifyFruit};|" ${FileFruit}
  else
    echo -e "${FileFruit}：NotifyFruit保持默认，东东农场将不静默运行，将发通知...\n"
  fi
}


################################## 修改东东农场是否使用水滴换豆卡 ##################################
function Change_jdFruitBeanCard {
  if [ "${jdFruitBeanCard}" = "true" ]
  then
    echo -e "${FileFruit}：修改东东农场是否使用水滴换豆卡为：${jdFruitBeanCard}，将在出现限时活动时使用100g水换20金豆，不浇水...\n"
    sed -i "s|let jdFruitBeanCard = false;|let jdFruitBeanCard = ${jdFruitBeanCard};|" ${FileFruit}
  else
    echo -e "${FileFruit}：jdFruitBeanCard保持默认，东东农场将在出现100g水换20金豆限时活动时继续浇水...\n"
  fi
}


################################## 修改宠汪汪喂食克数 ##################################
function Change_joyFeedCount {
  case ${joyFeedCount} in
    20 | 40 | 80)
      echo -e "${FileJoy}: 修改宠汪汪喂食克数为：${joyFeedCount}g...\n"
      echo -e "${FileJoyFeed}: 修改宠汪汪喂食克数为：${joyFeedCount}g...\n"
      perl -i -pe "s|let FEED_NUM = .+;|let FEED_NUM = ${joyFeedCount};|" ${FileJoy}
      perl -i -pe "s|let FEED_NUM = .+;|let FEED_NUM = ${joyFeedCount};|" ${FileJoyFeed};;
    10)
      echo -e "${FileJoy}: 宠汪汪喂食克数保持默认值：10g...\n"
      echo -e "${FileJoyFeed}: 宠汪汪喂食克数保持默认值：10g...\n";;
    *)
      echo -e "joyFeedCount输入了错误值，不修改宠汪汪喂食克数，保持默认值...\n";;
  esac
}


################################## 修改宠汪汪兑换京豆数量 ##################################
function Change_joyRewardName {
  case ${joyRewardName} in
    0)
      echo -e "${FileJoyReward}：禁用宠汪汪自动兑换京豆...\n"
      sed -i "s|let joyRewardName = 20;|let joyRewardName = ${joyRewardName};|" ${FileJoyReward};;
    500 | 1000)
      echo -e "${FileJoyReward}：修改宠汪汪兑换京豆数量为：${joyRewardName}...\n"
      sed -i "s|let joyRewardName = 20;|let joyRewardName = ${joyRewardName};|" ${FileJoyReward};;
    20)
      echo -e "${FileJoyReward}：宠汪汪兑换京豆数量保持默认值：20...\n";;
    *)
      echo -e "joyRewardName输入了错误值，宠汪汪兑换京豆数量保持默认值：20...\n";;
  esac
}


################################## 修改宠汪汪兑换京豆是否静默运行 ##################################
function Change_NotifyJoyReward {
  if [ "${NotifyJoyReward}" = "true" ]
  then
    echo -e "${FileJoyReward}：修改宠汪汪兑换京豆是否静默运行为：${NotifyJoyReward}，静默运行，不发通知...\n"
    sed -i "s|let jdNotify = false;|let jdNotify = ${NotifyJoyReward};|" ${FileJoyReward}
  else
    echo -e "${FileJoyReward}：NotifyJoyReward保持默认，宠汪汪兑换京豆成功时将发通知...\n"
  fi
}


################################## 修改宠汪汪偷取好友积分与狗粮是否静默运行 ##################################
function Change_NotifyJoySteal {
  if [ "${NotifyJoySteal}" = "true" ]
  then
    echo -e "${FileJoySteal}：修改宠汪汪偷取好友积分与狗粮是否静默运行为：${NotifyJoySteal}，静默运行，不发通知...\n"
    sed -i "s|let jdNotify = false;|let jdNotify = ${NotifyJoySteal};|" ${FileJoySteal}
  else
    echo -e "${FileJoySteal}：NotifyJoySteal保持默认，宠汪汪偷取好友积分与狗粮时将发通知...\n"
  fi
}


################################## 修改宠汪汪是否静默运行 ##################################
function Change_NotifyJoy {
  if [ "${NotifyJoy}" = "false" ]
  then
    echo -e "${FileJoy}：修改宠汪汪是否静默运行为：${NotifyJoy}，不静默运行，将发通知...\n"
    sed -i "s|let jdNotify = true;|let jdNotify = ${NotifyJoy};|" ${FileJoy}
  else
    echo -e "${FileJoy}：NotifyJoy保持默认，宠汪汪将静默运行，不发通知...\n"
  fi
}


################################## 修改宠汪汪是否自动报名宠物赛跑 ##################################
function Change_joyRunFlag {
  if [ "${joyRunFlag}" = "false" ]
  then
    echo -e "${FileJoy}：修改宠汪汪是否自动报名宠物赛跑为：${joyRunFlag}...\n"
    sed -i "s|let joyRunFlag = true;|let joyRunFlag = ${joyRunFlag};|" ${FileJoy}
  else
    echo -e "${FileJoy}：joyRunFlag保持默认，宠汪汪将自动报名宠物赛跑...\n"
  fi
}


################################## 修改宠汪汪是否自动给好友的汪汪喂食 ##################################
function Change_jdJoyHelpFeed {
  if [ "${jdJoyHelpFeed}" = "true" ]
  then
    echo -e "${FileJoySteal}：修改宠汪汪自动给好友的汪汪喂食为：${jdJoyHelpFeed}...\n"
    sed -i "s|let jdJoyHelpFeed = false;|let jdJoyHelpFeed = ${jdJoyHelpFeed};|" ${FileJoySteal}
  else
    echo -e "${FileJoySteal}：jdJoyHelpFeed保持默认，宠汪汪将不会给好友的汪汪喂食...\n"
  fi
}


################################## 修改宠汪汪是否自动偷好友积分与狗粮 ##################################
function Change_jdJoyStealCoin {
  if [ "${jdJoyStealCoin}" = "false" ]
  then
    echo -e "${FileJoySteal}：修改宠汪汪是否自动偷好友积分与狗粮为：${jdJoyStealCoin}...\n"
    sed -i "s|let jdJoyStealCoin = false;|let jdJoyStealCoin = ${jdJoyStealCoin};|" ${FileJoySteal}
  else
    echo -e "${FileJoySteal}：jdJoyStealCoin保持默认，宠汪汪将会自动偷取好友积分与狗粮...\n"
  fi
}


################################## 修改东东萌宠是否静默运行 ##################################
function Change_NotifyPet {
  if [ "${NotifyPet}" = "true" ]
  then
    echo -e "${FilePet}：修改东东萌宠是否静默运行为：${NotifyPet}，静默运行，不发通知...\n"
    sed -i "s|let jdNotify = false;|let jdNotify = ${NotifyPet};|" ${FilePet}
  else
    echo -e "${FilePet}：NotifyPet保持默认，东东萌宠将发通知...\n"
  fi
}


################################## 修改取关参数 ##################################
function Change_Unsubscribe {
  if [ ${goodPageSize} -gt 0 ]; then
    echo -e "${FileUnsubscribe}：修改店铺取关数量为：${shopPageSize}...\n"
    perl -i -pe "s|let goodPageSize = .+;|let goodPageSize = ${goodPageSize};|" ${FileUnsubscribe}
  fi
  if [ ${shopPageSize} -gt 0 ]; then
    echo -e "${FileUnsubscribe}：修改店铺取关数量为：${shopPageSize}...\n"
    perl -i -pe "s|let shopPageSize = .+;|let shopPageSize = ${shopPageSize};|" ${FileUnsubscribe}
  fi
  if [ ${jdUnsubscribeStopGoods} ]; then
    echo -e "修改禁止取关商品的截止关键字为：${jdUnsubscribeStopGoods}，遇到此商品不再取关此商品以及它后面的商品...\n"
    perl -i -pe "s|let stopGoods = .+;|let stopGoods = \'${jdUnsubscribeStopGoods}\';|" ${FileUnsubscribe}
  fi
  if [ ${jdUnsubscribeStopShop} ]; then
    echo -e "修改禁止取关店铺的截止关键字为：${jdUnsubscribeStopShop}，遇到此店铺不再取关此店铺以及它后面的店铺...\n"
    perl -i -pe "s|let stopShop = .+;|let stopShop = \'${jdUnsubscribeStopShop}\';|" ${FileUnsubscribe}
  fi
}


################################## 修改手机狂欢城是否发送上车提醒 ##################################
function Change_Notify818 {
  if [ "${Notify818}" = "true" ]
  then
    echo -e "${File818}：修改手机狂欢城是否发送上车提醒为：${Notify818}\n"
    sed -i "s|let jdNotify = false;|let jdNotify = ${Notify818};|" ${File818}
  else
    echo -e "${File818}：Notify818保持默认，手机狂欢城将不发送上车提醒...\n"
  fi
}


################################## 获取git修改状态 ##################################
function Git_Status {
  echo -e "获取git修改状态如下：\n"
  git status | grep "modified:" | sed "s/\s//g"
  echo
}


################################## 检测定时任务是否有变化 ##################################
## 此函数会在Log文件夹下生成四个文件，分别为：
## shell.list   shell文件夹下用来跑js文件的以“jd_”开头的所有 .sh 文件清单（去掉后缀.sh）
## js.list      scripts/docker/crontab_list.sh文件中用来运行js脚本的清单（非运行脚本的不会包括在内）
## js-add.list  如果 scripts/docker/crontab_list.sh 增加了定时任务，这个文件内容将不为空
## js-drop.list 如果 scripts/docker/crontab_list.sh 删除了定时任务，这个文件内容将不为空
function Cron_Different {
  ls ${ShellDir} | grep -E "jd_.+\.sh" | sed "s/\.sh//" > ${ListShell}
  cat ${ScriptsDir}/docker/crontab_list.sh | grep -E "jd_.+\.js" | awk -F " " '{print $7}' | sed "{s|/scripts/||;s|\.js||}" > ${ListJs}
  grep -v -f ${ListShell} ${ListJs} > ${ListJsAdd}
  grep -v -f ${ListJs} ${ListShell} > ${ListJsDrop}
}


################################## 依次修改上述设定的值 ##################################
cd ${ScriptsDir}
Detect_UserSum
DetectUserSumExitStatus=$?
if [ ${DetectUserSumExitStatus} -eq 0 ]; then
  PackageListOld=$(cat package.json)
  Git_PullScripts
  GitPullExitStatus=$?
fi

if [ ${GitPullExitStatus} -eq 0 ]
then
  echo -e "js脚本更新完成，开始替换信息...\n"
  Change_Cookie
  Change_Token
  Change_FruitShareCodes
  Change_PetShareCodes
  Change_PlantBeanShareCodes
#   Change_SuperMarketShareCodes
  Change_coinToBeans
  Change_NotifyBlueCoin
  Change_superMarketUpgrade
  Change_businessCircleJump
  Change_drawLotteryFlag
  Change_NotifyFruit
  Change_jdFruitBeanCard
  Change_joyFeedCount
  Change_joyRewardName
  Change_NotifyJoyReward
  Change_NotifyJoySteal
  Change_NotifyJoy
  Change_joyRunFlag
  Change_jdJoyHelpFeed
  Change_jdJoyStealCoin
  Change_NotifyPet
  Change_Unsubscribe
#  Change_Notify818
  Git_Status
  Cron_Different
else
  echo -e "js脚本更新失败，请检查原因或再次运行git_pull.sh...\n"
fi

## 检测是否有新的定时任务
if [ ${GitPullExitStatus} -eq 0 ] && [ -s ${ListJsAdd} ]; then
  echo -e "检测到有新的定时任务：\n"
  cat ${ListJsAdd}
  echo
fi
  
## 检测失效的定时任务  
if [ ${GitPullExitStatus} -eq 0 ] && [ -s ${ListJsDrop} ]; then
  echo -e "检测到失效的定时任务：\n"
  cat ${ListJsDrop}
  echo
fi
  

################################## 自动删除失效的脚本与定时任务 ##################################
## 如果检测到某个定时任务在 scripts/docker/crontab_list.sh 中已删除，那么在本地也删除对应的shell脚本与定时任务
## 此功能仅在 AutoDelCron 设置为 true 时生效
if [ ${GitPullExitStatus} -eq 0 ] && [ "${AutoDelCron}" = "true" ] && [ -s ${ListJsDrop} ]; then
  echo -e "开始尝试自动删除定时任务如下：\n"
  cat ${ListJsDrop}
  echo
  JsDrop=$(cat ${ListJsDrop})
  for Cron in ${JsDrop}
  do
    sed -i "/\/${Cron}\.sh/d" ${ListCron}
    rm -f "${ShellDir}/${Cron}.sh"
  done
  crontab ${ListCron}
  echo -e "成功删除失效的脚本与定时任务，当前的定时任务清单如下：\n"
  crontab -l
  echo
fi


################################## 自动增加新的定时任务 ##################################
## 如果检测到 scripts/docker/crontab_list.sh 中增加新的定时任务，那么在本地也增加
## 此功能仅在 AutoAddCron 设置为 true 时生效
## 本功能生效时，会自动从 scripts/docker/crontab_list.sh 文件新增加的任务中读取时间，该时间为北京时间
if [ ${GitPullExitStatus} -eq 0 ] && [ "${AutoAddCron}" = "true" ] && [ -s ${ListJsAdd} ]; then
  echo -e "开始尝试自动添加定时任务如下：\n"
  cat ${ListJsAdd}
  echo
  JsAdd=$(cat ${ListJsAdd})
  if [ -f ${ShellDir}/jd.sh.sample ]
  then
    for Cron in ${JsAdd}
    do
      grep ${Cron} "${ScriptsDir}/docker/crontab_list.sh" | awk -F " >> " '{print $1}' | sed "{s|node /scripts|/root/shell|;s|\.js|\.sh|}" >> ${ListCron}
    done
    if [ $? -eq 0 ]
    then
      for Cron in ${JsAdd}
      do
        cp -fv "${ShellDir}/jd.sh.sample" "${ShellDir}/${Cron}.sh"
        chmod +x "${ShellDir}/${Cron}.sh"
      done
      crontab ${ListCron}
      echo -e "成功添加新的定时任务，当前的定时任务清单如下：\n"
      crontab -l
      echo
    else
      echo -e "未能添加新的定时任务，请自行添加...\n"
    fi
  else
    echo -e "${ShellDir}/jd.sh.sample 文件不存在，可能是shell脚本克隆不正常...\n未能成功添加新的定时任务，请自行添加...\n"
  fi
fi


################################## npm install ##################################
if [ ${GitPullExitStatus} -eq 0 ]; then
  PackageListNew=$(cat package.json)
  if [ "${PackageListOld}" != "${PackageListNew}" ]; then
    echo -e "检测到 ${ScriptsDir}/package.json 内容有变化，再次运行 npm install...\n"
    npm install || npm install --registry=https://registry.npm.taobao.org
    if [ $? -ne 0 ]; then
      echo -e "\nnpm install 运行不成功，自动删除 ${ScriptsDir}/node_modules 后再次尝试一遍..."
      rm -rf ${ScriptsDir}/node_modules
    fi
    echo
  fi
  if [ ! -d ${ScriptsDir}/node_modules ]; then
    echo -e "运行npm install...\n"
    npm install || npm install --registry=https://registry.npm.taobao.org
    if [ $? -ne 0 ]; then
      echo -e "\nnpm install 运行不成功，自动删除 ${ScriptsDir}/node_modules...\n请进入 ${ScriptsDir} 目录后手动运行 npm install，或等待定时任务再次运行git_pull.sh ..."
      rm -rf ${ScriptsDir}/node_modules
    fi
    echo
  fi
fi


################################## 更新shell脚本 ##################################
function Git_PullShell {
  echo "更新shell脚本，原地址：${ShellURL}"
  echo
  git fetch --all
  git reset --hard origin/main
  git pull
  if [ $? -eq 0 ]
  then
    echo -e "\nshell脚本更新完成...\n"
  else
    echo -e "\nshell脚本更新失败，请检查原因后再次运行git_pull.sh，或等待定时任务自动再次运行git_pull.sh...\n"
  fi
}

if [ ${DetectUserSumExitStatus} -eq 0 ]; then
  cd ${ShellDir}
  Git_PullShell
fi



