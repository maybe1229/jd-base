#!/bin/sh

## 修改日期：2020-11-07
## 作者：Evine Deng <evinedeng@foxmail.com>

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export LC_ALL=C


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
echo
echo "-------------------------------------------------------------------"
echo
echo -n "当前时间："
echo $(date "+%Y-%m-%d %H:%M:%S")
echo
echo "SHELL脚本目录：${ShellDir}"
echo 
echo "JS脚本目录：${ScriptsDir}"
echo
echo "-------------------------------------------------------------------"
echo


################################## 更新JS脚本 ##################################
function Git_PullScripts {
  echo "更新JS脚本，原地址：${ScriptsURL}"
  echo
  git fetch --all
  git reset --hard origin/master
  git pull
}


################################## 修改JS脚本中的Cookie ##################################
function Change_Cookie {
  CookieALL=""
  echo "${FileCookie}: 替换Cookies..."
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
    echo "${FileNotify}: 替换ServerChan推送通知SCKEY..."
    sed -i "s|let SCKEY = '';|let SCKEY = '${SCKEY}';|" ${FileNotify}
    echo
  fi

  ## BARK
  if [ ${BARK_PUSH} ] && [ ${BARK_SOUND} ]; then
    echo "${FileNotify}: 替换BARK推送通知BARK_PUSH、BARK_SOUND..."
    sed -i "s|let BARK_PUSH = '';|let BARK_PUSH = '${BARK_PUSH}';|" ${FileNotify}
    sed -i "s|let BARK_SOUND = '';|let BARK_SOUND = '${BARK_SOUND}';|" ${FileNotify}
    echo
  fi

  ## Telegram
  if [ ${TG_BOT_TOKEN} ] && [ ${TG_USER_ID} ]; then
    echo "${FileNotify}: 替换Telegram推送通知TG_BOT_TOKEN、TG_USER_ID..."
    sed -i "s|let TG_BOT_TOKEN = '';|let TG_BOT_TOKEN = '${TG_BOT_TOKEN}';|" ${FileNotify}
    sed -i "s|let TG_USER_ID = '';|let TG_USER_ID = '${TG_USER_ID}';|" ${FileNotify}
    echo
  fi

  ## 钉钉
  if [ ${DD_BOT_TOKEN} ]; then
    echo "${FileNotify}: 替换钉钉推送通知DD_BOT..."
    sed -i "s|let DD_BOT_TOKEN = '';|let DD_BOT_TOKEN = '${DD_BOT_TOKEN}';|" ${FileNotify}
    echo
    if [ ${DD_BOT_SECRET} ]; then
      sed -i "s|let DD_BOT_SECRET = '';|let DD_BOT_SECRET = '${DD_BOT_SECRET}';|" ${FileNotify}
    fi
  fi
  
  ## 未输入任何通知渠道
  if [ -z "${SCKEY}" ] && [ -z "${BARK_PUSH}" ] && [ -z "${BARK_SOUND}" ] && [ -z "${TG_BOT_TOKEN}" ] && [ -z "${TG_USER_ID}" ] && [ -z "${DD_BOT_TOKEN}" ] && [ -z "${DD_BOT_SECRET}" ]; then
    echo "没有有效的通知渠道，将不发送任何通知，请直接在本地查看日志..."
    echo
  fi
}


################################## 替换东东农场互助码 ##################################
function Change_FruitShareCodes {
  ForOtherFruitALL=""
  echo "${FileFruitShareCodes}: 替换东东农场互助码..."
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
  echo "${FilePetShareCodes}: 替换东东萌宠互助码..."
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
  echo "${FilePlantBeanShareCodes}: 替换种豆得豆互助码..."
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
#   echo "${FileSuperMarketShareCodes}: 替换东东超市商圈互助码..."
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
        echo "${FileBlueCoin}: 修改东东超市蓝币兑换 ${coinToBeans} 个京豆..."
        perl -i -pe "s|let coinToBeans = .+;|let coinToBeans = ${coinToBeans};|" ${FileBlueCoin};;
      0)
        echo "${FileBlueCoin}: 东东超市不自动兑换蓝币，保持默认...";;
      *)
        echo "${FileBlueCoin}: coinToBeans输入了错误的数字，东东超市不自动兑换蓝币，保持默认...";;
    esac
  else
    echo "${FileBlueCoin}: 修改东东超市蓝币兑换实物奖品：${coinToBeans}，该奖品是否可兑换以js运行日志为准..."
    perl -i -pe "s|let coinToBeans = .+;|let coinToBeans = \'${coinToBeans}\';|" ${FileBlueCoin}
  fi
}


################################## 修改东东超市蓝币成功兑换奖品是否静默运行 ##################################
function Change_NotifyBlueCoin {
  if [ "${NotifyBlueCoin}" = "true" ]
  then
    echo "${FileBlueCoin}：修改东东超市成功兑换蓝币是否静默运行：${NotifyBlueCoin}，成功兑换后静默运行不发通知..."
    sed -i "s|let jdNotify = false;|let jdNotify = ${NotifyBlueCoin};|" ${FileBlueCoin}
  else
    echo "${FileBlueCoin}：NotifyBlueCoin保持默认，东东超市成功兑换蓝币后将发通知..."
  fi
}


################################## 修改东东超市是否自动升级商品和货架 ##################################
function Change_superMarketUpgrade {
  if [ "${superMarketUpgrade}" = "false" ]
  then
    echo "${FileSuperMarket}：修改东东超市是否自动升级商品和货架为：${superMarketUpgrade}，不自动升级..."
    sed -i "s|let superMarketUpgrade = true;|let superMarketUpgrade = ${superMarketUpgrade};|" ${FileSuperMarket}
  else
    echo "${FileSuperMarket}：superMarketUpgrade保持默认，东东超市将默认自动升级商品和货架..."
  fi
}


################################## 修改东东超市是否自动更换商圈 ##################################
function Change_businessCircleJump {
  if [ "${businessCircleJump}" = "false" ]
  then
    echo "${FileSuperMarket}：修改东东超市在小于对方300热力值时是否自动更换商圈为：${businessCircleJump}"
    sed -i "s|let businessCircleJump = true;|let businessCircleJump = ${businessCircleJump};|" ${FileSuperMarket}
  else
    echo "${FileSuperMarket}：businessCircleJump保持默认，东东超市将在小于对方300热力值时自动更换商圈..."
  fi
}


################################## 修改东东超市是否自动使用金币去抽奖 ##################################
function Change_drawLotteryFlag {
  if [ "${drawLotteryFlag}" = "true" ]
  then
    echo "${FileSuperMarket}：修改东东超市是否自动使用金币去抽奖为：${drawLotteryFlag}，自动使用金币去抽奖..."
    sed -i "s|let drawLotteryFlag = false;|let drawLotteryFlag = ${drawLotteryFlag};|" ${FileSuperMarket}
  else
    echo "${FileSuperMarket}：drawLotteryFlag保持默认，东东超市将不去抽奖..."
  fi
}


################################## 修改东东农场是否静默运行 ##################################
function Change_NotifyFruit {
  if [ "${NotifyFruit}" = "true" ]
  then
    echo "${FileFruit}：修改东东农场是否静默运行为：${NotifyFruit}，静默运行，不发通知..."
    sed -i "s|let jdNotify = false;|let jdNotify = ${NotifyFruit};|" ${FileFruit}
  else
    echo "${FileFruit}：NotifyFruit保持默认，东东农场将不静默运行，将发通知..."
  fi
}


################################## 修改东东农场是否使用水滴换豆卡 ##################################
function Change_jdFruitBeanCard {
  if [ "${jdFruitBeanCard}" = "true" ]
  then
    echo "${FileFruit}：修改东东农场是否使用水滴换豆卡为：${jdFruitBeanCard}，将在出现限时活动时使用100g水换20金豆，不浇水..."
    sed -i "s|let jdFruitBeanCard = false;|let jdFruitBeanCard = ${jdFruitBeanCard};|" ${FileFruit}
  else
    echo "${FileFruit}：jdFruitBeanCard保持默认，东东农场将在出现100g水换20金豆限时活动时继续浇水..."
  fi
}


################################## 修改宠汪汪喂食克数 ##################################
function Change_joyFeedCount {
  case ${joyFeedCount} in
    20 | 40 | 80)
      echo "${FileJoy}: 修改宠汪汪喂食克数为：${joyFeedCount}g..."
      echo
      echo "${FileJoyFeed}: 修改宠汪汪喂食克数为：${joyFeedCount}g..."
      perl -i -pe "s|let FEED_NUM = .+;|let FEED_NUM = ${joyFeedCount};|" ${FileJoy}
      perl -i -pe "s|let FEED_NUM = .+;|let FEED_NUM = ${joyFeedCount};|" ${FileJoyFeed};;
    10)
      echo "${FileJoy}: 宠汪汪喂食克数保持默认值：10g..."
      echo
      echo "${FileJoyFeed}: 宠汪汪喂食克数保持默认值：10g...";;
    *)
      echo "joyFeedCount输入了错误值，不修改宠汪汪喂食克数，保持默认值...";;
  esac
}


################################## 修改宠汪汪兑换京豆数量 ##################################
function Change_joyRewardName {
  case ${joyRewardName} in
    0)
      echo "${FileJoyReward}：禁用宠汪汪自动兑换京豆..."
      sed -i "s|let joyRewardName = 20;|let joyRewardName = ${joyRewardName};|" ${FileJoyReward};;
    500 | 1000)
      echo "${FileJoyReward}：修改宠汪汪兑换京豆数量为：${joyRewardName}..."
      sed -i "s|let joyRewardName = 20;|let joyRewardName = ${joyRewardName};|" ${FileJoyReward};;
    20)
      echo "${FileJoyReward}：宠汪汪兑换京豆数量保持默认值：20...";;
    *)
      echo "joyRewardName输入了错误值，宠汪汪兑换京豆数量保持默认值：20...";;
  esac
}


################################## 修改宠汪汪兑换京豆是否静默运行 ##################################
function Change_NotifyJoyReward {
  if [ "${NotifyJoyReward}" = "true" ]
  then
    echo "${FileJoyReward}：修改宠汪汪兑换京豆是否静默运行为：${NotifyJoyReward}，静默运行，不发通知..."
    sed -i "s|let jdNotify = false;|let jdNotify = ${NotifyJoyReward};|" ${FileJoyReward}
  else
    echo "${FileJoyReward}：NotifyJoyReward保持默认，宠汪汪兑换京豆成功时将发通知..."
  fi
}


################################## 修改宠汪汪偷取好友积分与狗粮是否静默运行 ##################################
function Change_NotifyJoySteal {
  if [ "${NotifyJoySteal}" = "true" ]
  then
    echo "${FileJoySteal}：修改宠汪汪偷取好友积分与狗粮是否静默运行为：${NotifyJoySteal}，静默运行，不发通知..."
    sed -i "s|let jdNotify = false;|let jdNotify = ${NotifyJoySteal};|" ${FileJoySteal}
  else
    echo "${FileJoySteal}：NotifyJoySteal保持默认，宠汪汪偷取好友积分与狗粮时将发通知..."
  fi
}


################################## 修改宠汪汪是否静默运行 ##################################
function Change_NotifyJoy {
  if [ "${NotifyJoy}" = "false" ]
  then
    echo "${FileJoy}：修改宠汪汪是否静默运行为：${NotifyJoy}，不静默运行，将发通知..."
    sed -i "s|let jdNotify = true;|let jdNotify = ${NotifyJoy};|" ${FileJoy}
  else
    echo "${FileJoy}：NotifyJoy保持默认，宠汪汪将静默运行，不发通知..."
  fi
}


################################## 修改宠汪汪是否自动报名宠物赛跑 ##################################
function Change_joyRunFlag {
  if [ "${joyRunFlag}" = "false" ]
  then
    echo "${FileJoy}：修改宠汪汪是否自动报名宠物赛跑为：${joyRunFlag}..."
    sed -i "s|let joyRunFlag = true;|let joyRunFlag = ${joyRunFlag};|" ${FileJoy}
  else
    echo "${FileJoy}：joyRunFlag保持默认，宠汪汪将自动报名宠物赛跑..."
  fi
}


################################## 修改宠汪汪是否自动给好友的汪汪喂食 ##################################
function Change_jdJoyHelpFeed {
  if [ "${jdJoyHelpFeed}" = "true" ]
  then
    echo "${FileJoySteal}：修改宠汪汪自动给好友的汪汪喂食为：${jdJoyHelpFeed}..."
    sed -i "s|let jdJoyHelpFeed = false;|let jdJoyHelpFeed = ${jdJoyHelpFeed};|" ${FileJoySteal}
  else
    echo "${FileJoySteal}：jdJoyHelpFeed保持默认，宠汪汪将不会给好友的汪汪喂食..."
  fi
}


################################## 修改宠汪汪是否自动偷好友积分与狗粮 ##################################
function Change_jdJoyStealCoin {
  if [ "${jdJoyStealCoin}" = "false" ]
  then
    echo "${FileJoySteal}：修改宠汪汪是否自动偷好友积分与狗粮为：${jdJoyStealCoin}..."
    sed -i "s|let jdJoyStealCoin = false;|let jdJoyStealCoin = ${jdJoyStealCoin};|" ${FileJoySteal}
  else
    echo "${FileJoySteal}：jdJoyStealCoin保持默认，宠汪汪将会自动偷取好友积分与狗粮..."
  fi
}


################################## 修改东东萌宠是否静默运行 ##################################
function Change_NotifyPet {
  if [ "${NotifyPet}" = "true" ]
  then
    echo "${FilePet}：修改东东萌宠是否静默运行为：${NotifyPet}，静默运行，不发通知..."
    sed -i "s|let jdNotify = false;|let jdNotify = ${NotifyPet};|" ${FilePet}
  else
    echo "${FilePet}：NotifyPet保持默认，东东萌宠将发通知..."
  fi
}


################################## 修改取关参数 ##################################
function Change_Unsubscribe {
  if [ ${goodPageSize} -gt 0 ]; then
    echo "${FileUnsubscribe}：修改店铺取关数量为：${shopPageSize}..."
    perl -i -pe "s|let goodPageSize = .+;|let goodPageSize = ${goodPageSize};|" ${FileUnsubscribe}
    echo
  fi
  if [ ${shopPageSize} -gt 0 ]; then
    echo "${FileUnsubscribe}：修改店铺取关数量为：${shopPageSize}..."
    perl -i -pe "s|let shopPageSize = .+;|let shopPageSize = ${shopPageSize};|" ${FileUnsubscribe}
    echo
  fi
  if [ ${jdUnsubscribeStopGoods} ]; then
    echo "修改禁止取关商品的截止关键字为：${jdUnsubscribeStopGoods}，遇到此商品不再取关此商品以及它后面的商品..."
    perl -i -pe "s|let stopGoods = .+;|let stopGoods = \'${jdUnsubscribeStopGoods}\';|" ${FileUnsubscribe}
    echo
  fi
  if [ ${jdUnsubscribeStopShop} ]; then
    echo "修改禁止取关店铺的截止关键字为：${jdUnsubscribeStopShop}，遇到此店铺不再取关此店铺以及它后面的店铺..."
    perl -i -pe "s|let stopShop = .+;|let stopShop = \'${jdUnsubscribeStopShop}\';|" ${FileUnsubscribe}
    echo
  fi
}


################################## 修改手机狂欢城是否发送上车提醒 ##################################
function Change_Notify818 {
  if [ "${Notify818}" = "true" ]
  then
    echo "${File818}：修改手机狂欢城是否发送上车提醒为：${Notify818}"
    sed -i "s|let jdNotify = false;|let jdNotify = ${Notify818};|" ${File818}
  else
    echo "${File818}：Notify818保持默认，手机狂欢城将不发送上车提醒..."
  fi
}


################################## 获取git修改状态 ##################################
function Git_Status {
  echo "获取git修改状态如下："
  echo
  git status | grep "modified:" | sed "s/\s//g"
}


################################## 检测Github Action定时任务是否有变化 ##################################
## 此函数会在Log文件夹下生成四个文件，分别为：
## shell.list   shell文件夹下用来跑js文件的以“jd_”开头的所有 .sh 文件清单（去掉后缀.sh）
## js.list      scripts/.github/workflows下所有以“jd_”开头的所有 .yml 文件清单（去掉后缀.yml），这是 lxk0301@github 大佬定义的所有GitHub Action定时任务
## js-add.list  如果 scripts/.github/workflows 增加了定时任务，这个文件内容将不为空
## js-drop.list 如果 scripts/.github/workflows 删除了定时任务，这个文件内容将不为空
function Cron_Different {
  ls ${ShellDir} | grep -E "jd_.+\.sh" | sed "s/\.sh//" > ${ListShell}
  ls ${ScriptsDir}/.github/workflows | grep -E "jd_.+\.yml" | sed "s/\.yml//" > ${ListJs}
  grep -v -f ${ListShell} ${ListJs} > ${ListJsAdd}
  grep -v -f ${ListJs} ${ListShell} > ${ListJsDrop}
}


################################## 依次修改上述设定的值 ##################################
cd ${ScriptsDir}
Git_PullScripts
GitPullExitStatus=$?
if [ ${GitPullExitStatus} -eq 0 ]
then
  echo
  echo "更新JS脚本完成..."
  echo
  Change_Cookie
  echo
  Change_Token
  Change_FruitShareCodes
  echo
  Change_PetShareCodes
  echo
  Change_PlantBeanShareCodes
  echo
#   Change_SuperMarketShareCodes
#   echo
  Change_coinToBeans
  echo
  Change_NotifyBlueCoin
  echo
  Change_superMarketUpgrade
  echo
  Change_businessCircleJump
  echo
  Change_drawLotteryFlag
  echo
  Change_NotifyFruit
  echo
  Change_jdFruitBeanCard
  echo
  Change_joyFeedCount
  echo
  Change_joyRewardName
  echo
  Change_NotifyJoyReward
  echo
  Change_NotifyJoySteal
  echo
  Change_NotifyJoy
  echo
  Change_joyRunFlag
  echo
  Change_jdJoyHelpFeed
  echo
  Change_jdJoyStealCoin
  echo
  Change_NotifyPet
  echo
  Change_Unsubscribe
  Change_Notify818
  echo
  Git_Status
  echo
  Cron_Different
  
  ## 检测是否有新的定时任务
  if [ -s ${ListJsAdd} ]  
  then
    echo "检测到有新的定时任务："
	cat ${ListJsAdd}
  else
    echo "没有检测到新的定时任务..."
  fi
  echo
  
  ## 检测失效的定时任务  
  if [ -s ${ListJsDrop} ]
  then
    echo "检测到失效的定时任务："
	cat ${ListJsDrop}
  else
    echo "没有检测到失效的定时任务..."
  fi
  echo
  
else
  echo "JS脚本拉取不正常，所有JS文件将保持上一次的状态..."
  echo

fi


################################## 自动删除失效的脚本与定时任务 ##################################
## 如果检测到某个定时任务在https://github.com/lxk0301/scripts中已删除，那么在本地也删除对应的shell脚本与定时任务
## 此功能仅在 AutoDelCron 设置为 true 时生效
if [ ${GitPullExitStatus} -eq 0 ] && [ "${AutoDelCron}" = "true" ] && [ -s ${ListJsDrop} ]; then
  echo "开始尝试自动删除定时任务如下："
  echo
  cat ${ListJsDrop}
  echo
  JsDrop=$(cat ${ListJsDrop})
  for i in ${JsDrop}
  do
    sed -i "/\/$i\.sh/d" ${ListCron}
    rm -f "${ShellDir}/$i.sh"
  done
  crontab ${ListCron}
  echo "成功删除失效的脚本与定时任务，当前的定时任务清单如下："
  echo
  crontab -l
  echo
fi


################################## 自动增加新的定时任务 ##################################
## 如果检测到https://github.com/lxk0301/scripts中增加新的Guthub Action定时任务，那么在本地也增加
## 此功能仅在 AutoAddCron 设置为 true 时生效
## 本功能生效时，会自动从 scripts/.github/workflows 文件夹新增加的 .yml 文件中读取 cron 这一行的任务时间，
## 但因为Github Action定时任务采用的是UTC时间，比北京时间晚8小时，所以会导致本地任务无法真正地在准确设定的时间运行，需要手动修改crontab
## 如果你在部署容器时，添加了环境变量TZ=UTC，则容器也将使用UTC时间，这样自动增加定时任务就可以和lxk0301设置的时间一致，不过crontab初始的定时任务需要修改一下
## 两种时区时间对应关系见 https://datetime360.com/cn/utc-beijing-time/ 或 http://www.timebie.com/cn/universalbeijing.php
if [ ${GitPullExitStatus} -eq 0 ] && [ "${AutoAddCron}" = "true" ] && [ -s ${ListJsAdd} ]; then
  echo "开始尝试自动添加定时任务如下："
  echo
  cat ${ListJsAdd}
  echo
  JsAdd=$(cat ${ListJsAdd})
  if [ -f ${ShellDir}/jd.sh.sample ]
  then
	for i in ${JsAdd}
	do
	  grep "cron:" "${ScriptsDir}/.github/workflows/$i.yml" | awk -F "'" '{print $2}' | sed "s|$|& $ShellDir/$i\.sh|" >> ${ListCron}
	done
	if [ $? -eq 0 ]
	then
	  for j in ${JsAdd}
	  do
	    cp -fv "${ShellDir}/jd.sh.sample" "${ShellDir}/$j.sh"
	    chmod +x "${ShellDir}/$j.sh"
	  done
	  crontab ${ListCron}
	  echo "成功添加新的定时任务，当前的定时任务清单如下："
	  echo
	  crontab -l
	else
      echo "未能添加新的定时任务，请自行添加..."
      echo
	fi
	echo
  else
	echo "${ShellDir}/jd.sh.sample 文件不存在，请先克隆${ShellURL}..."
    echo
	echo "未能成功添加新的定时任务，请自行添加..."
    echo
  fi
fi


################################## npm install ##################################
echo "运行npm install"
echo
npm install
echo


################################## 更新shell脚本 ##################################
cd ${ShellDir}
echo "更新shell脚本，原地址：${ShellURL}"
echo
git fetch --all
git reset --hard origin/main
git pull


