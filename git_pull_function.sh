#!/usr/bin/env bash

## Author: Evine Deng
## Source: https://github.com/EvineDeng/jd-base
## Modified： 2020-12-17
## Version： v2.4.5

## 文件路径
RootDir=$(cd $(dirname $0); cd ..; pwd)
LogDir=${RootDir}/log
ScriptsDir=${RootDir}/scripts
ScriptsURL=https://github.com/lxk0301/jd_scripts
ShellURL=https://github.com/EvineDeng/jd-base
FileJdSample=${ShellDir}/jd.sh.sample
ListShell=${LogDir}/shell.list
ListJs=${LogDir}/js.list
ListJsAdd=${LogDir}/js-add.list
ListJsDrop=${LogDir}/js-drop.list
ListCron=${RootDir}/crontab.list
ListShellDir=$(ls ${ShellDir}/*.* | grep -E "/j[dr]_\w+\.a?sh")

## js脚本名称
FileBeanSign=jd_bean_sign.js
FileCookie=jdCookie.js
FileNotify=sendNotify.js
FileFruitShareCodes=jdFruitShareCodes.js
FilePetShareCodes=jdPetShareCodes.js
FilePlantBeanShareCodes=jdPlantBeanShareCodes.js
FileSuperMarketShareCodes=jdSuperMarketShareCodes.js
FileJdFactoryShareCodes=jdFactoryShareCodes.js
FileDreamFactoryShareCodes=jdDreamFactoryShareCodes.js
FileJoy=jd_joy.js
FileJoyFeed=jd_joy_feedPets.js
FileJoyReward=jd_joy_reward.js
FileJoyRun=jd_joy_run.js
FileJoySteal=jd_joy_steal.js
FileBlueCoin=jd_blueCoin.js
FileSuperMarket=jd_superMarket.js
FileFruit=jd_fruit.js
FilePet=jd_pet.js
File818=jd_818.js
FileUnsubscribe=jd_unsubscribe.js
FileDreamFactory=jd_dreamFactory.js
FileJdFactory=jd_jdfactory.js
FileMoneyTree=jd_moneyTree.js

## 在日志中记录时间与路径
echo -e "\n--------------------------------------------------------------\n"
echo -n "系统时间："
echo $(date "+%Y-%m-%d %H:%M:%S")
if [ "${TZ}" = "UTC" ]; then
  echo
  echo -n "北京时间："
  echo $(date -d "8 hour" "+%Y-%m-%d %H:%M:%S")
fi
echo -e "\nSHELL脚本目录：${ShellDir}\n"
echo -e "JS脚本目录：${ScriptsDir}\n"
echo -e "--------------------------------------------------------------\n"

## 检测jd_*.sh文件是否最新
function Detect_VerJdShell {
  VerSample=$(cat ${FileJdSample} | grep -i "Version" | perl -pe "s|.+v((\d+\.?){3})|\1|")
  for file in ${ListShellDir}
  do
    VerJdShell=$(cat ${file} | grep -i "Version" | perl -pe "s|.+v((\d+\.?){3})|\1|")
    if [ -z "${VerJdShell}" ] || [ "${VerJdShell}" != "${VerSample}" ]; then
      cp -f ${FileJdSample} ${file}
    fi
    [ ! -x ${file} ] && chmod +x ${file}
  done
}

## 判断是否输入用户数量
function Detect_UserSum {
  if [ -z "${UserSum}" ]; then
    echo -e "请输入有效的用户数量(UserSum)...\n"
    exit 1
  fi
}

## git更新js脚本
function Git_PullScripts {
  echo -e "更新JS脚本，原地址：${ScriptsURL}\n"
  git fetch --all
  git reset --hard origin/master
  echo
}

## 修改js脚本中的Cookie
function Change_Cookie {
  CookieALL=""
  echo -e "${FileCookie}: 替换Cookies...\n"
  i=1
  while [ ${i} -le ${UserSum} ]
  do
    TmpCK=Cookie${i}
    eval CookieTemp=$(echo \$${TmpCK})
    CookieALL="${CookieALL}\\n  '${CookieTemp}',"
    let i++
  done
  perl -0777 -i -pe "s|(let CookieJDs = )\[\n(.+\n?){2}\]|\1\[${CookieALL}\n\]|" ${FileCookie}
}

## 修改通知TOKEN
function Change_Token {
  ## ServerChan
  if [ ${SCKEY} ]; then
    echo -e "${FileNotify}: 替换ServerChan推送通知SCKEY...\n"
    perl -i -pe "s|let SCKEY = '';|let SCKEY = '${SCKEY}';|" ${FileNotify}
  fi

  ## BARK
  if [ ${BARK_PUSH} ] && [ ${BARK_SOUND} ]; then
    echo -e "${FileNotify}: 替换BARK推送通知BARK_PUSH、BARK_SOUND...\n"
    perl -i -pe "{s|(let BARK_PUSH = )'';|\1'${BARK_PUSH}';|; s|(let BARK_SOUND = )'';|\1'${BARK_SOUND}';|}" ${FileNotify}
  fi

  ## Telegram
  if [ ${TG_BOT_TOKEN} ] && [ ${TG_USER_ID} ]; then
    echo -e "${FileNotify}: 替换Telegram推送通知TG_BOT_TOKEN、TG_USER_ID...\n"
    perl -i -pe "{s|(let TG_BOT_TOKEN = )'';|\1'${TG_BOT_TOKEN}';|; s|(let TG_USER_ID = )'';|\1'${TG_USER_ID}';|}" ${FileNotify}
  fi

  ## 钉钉
  if [ ${DD_BOT_TOKEN} ]; then
    echo -e "${FileNotify}: 替换钉钉推送通知DD_BOT...\n"
    perl -i -pe "s|let DD_BOT_TOKEN = '';|let DD_BOT_TOKEN = '${DD_BOT_TOKEN}';|" ${FileNotify}
    if [ ${DD_BOT_SECRET} ]; then
      perl -i -pe "s|let DD_BOT_SECRET = '';|let DD_BOT_SECRET = '${DD_BOT_SECRET}';|" ${FileNotify}
    fi
  fi

  ## iGot
  if [ ${IGOT_PUSH_KEY} ]; then
    echo -e "${FileNotify}: 替换iGot推送KEY...\n"
    perl -i -pe "s|let IGOT_PUSH_KEY = '';|let IGOT_PUSH_KEY = '${IGOT_PUSH_KEY}';|" ${FileNotify}
  fi

  ## 未输入任何通知渠道
  if [ -z "${SCKEY}" ] && [ -z "${BARK_PUSH}" ] && [ -z "${BARK_SOUND}" ] && [ -z "${TG_BOT_TOKEN}" ] && [ -z "${TG_USER_ID}" ] && [ -z "${DD_BOT_TOKEN}" ] && [ -z "${DD_BOT_SECRET}" ] && [ -z "${IGOT_PUSH_KEY}" ]; then
    echo -e "没有有效的通知渠道，将不发送任何通知，请直接在本地查看日志...\n"
  fi
}

## 修改每日签到的延迟时间
function Change_BeanSignStop {
  if [ ${BeanSignStop} ] && [ ${BeanSignStop} -gt 0 ]; then
    echo -e "${FileBeanSign}：设置每日签到每个接口延迟时间为 ${BeanSignStop} ms...\n"
    perl -0777 -i -pe "s|if \(process\.env\.JD_BEAN_STOP.+\{\s+(\S.+, ).+(\);)\s+\}|\1\"var stop = ${BeanSignStop}\"\2|" ${FileBeanSign}
  fi
}

## 替换东东农场互助码
function Change_FruitShareCodes {
  ForOtherFruitALL=""
  echo -e "${FileFruitShareCodes}: 替换东东农场互助码...\n"
  i=1
  while [ ${i} -le ${UserSum} ]
  do
    TmpFR=ForOtherFruit${i}
    eval ForOtherFruitTemp=$(echo \$${TmpFR})
    ForOtherFruitALL="${ForOtherFruitALL}\\n  '${ForOtherFruitTemp}\@e6e04602d5e343258873af1651b603ec\@52801b06ce2a462f95e1d59d7e856ef4\@e2fd1311229146cc9507528d0b054da8\@6dc9461f662d490991a31b798f624128',"
    let i++
  done
  perl -0777 -i -pe "s|(let FruitShareCodes = )\[\n(.+\n?){2}\]|\1\[${ForOtherFruitALL}\n\]|" ${FileFruitShareCodes}
}

## 替换东东萌宠互助码
function Change_PetShareCodes {
  ForOtherPetALL=""
  echo -e "${FilePetShareCodes}: 替换东东萌宠互助码...\n"
  i=1
  while [ ${i} -le ${UserSum} ]
  do
    TmpPT=ForOtherPet${i}
    eval ForOtherPetTemp=$(echo \$${TmpPT})
    ForOtherPetALL="${ForOtherPetALL}\\n  '${ForOtherPetTemp}',"
    let i++
  done
  perl -0777 -i -pe "s|(let PetShareCodes = )\[\n(.+\n?){2}\]|\1\[${ForOtherPetALL}\n\]|" ${FilePetShareCodes}
}

## 替换种豆得豆互助码
function Change_PlantBeanShareCodes {
  ForOtherPlantBeanALL=""
  echo -e "${FilePlantBeanShareCodes}: 替换种豆得豆互助码...\n"
  i=1
  while [ ${i} -le ${UserSum} ]
  do
    TmpPB=ForOtherPlantBean${i}
    eval ForOtherPlantBeanTemp=$(echo \$${TmpPB})
    ForOtherPlantBeanALL="${ForOtherPlantBeanALL}\\n  '${ForOtherPlantBeanTemp}\@mze7pstbax4l7u5ggn5y2olhfy\@3nwlq2wyvmz7sn4d5akh4rnrczsih2dehcx7as4ym6fgb3q7y5tq\@olmijoxgmjutybihibx67mwivxbag4rjviz3cji\@rsuben7ys7sfbu5eub7knbibke',"
    let i++
  done
  perl -0777 -i -pe "s|(let PlantBeanShareCodes = )\[\n(.+\n?){2}\]|\1\[${ForOtherPlantBeanALL}\n\]|" ${FilePlantBeanShareCodes}
}

## 替换京喜工厂互助码
function Change_DreamFactoryShareCodes {
  ForOtherDreamFactoryALL=""
  echo -e "${FileDreamFactoryShareCodes}: 替换京喜工厂互助码...\n"
  i=1
  while [ ${i} -le ${UserSum} ]
  do
    TmpDF=ForOtherDreamFactory${i}
    eval ForOtherDreamFactoryTemp=$(echo \$${TmpDF})
    ForOtherDreamFactoryALL="${ForOtherDreamFactoryALL}\\n  '${ForOtherDreamFactoryTemp}',"
    let i++
  done
  perl -0777 -i -pe "s|(let shareCodes = )\[\n(.+\n?){2}\]|\1\[${ForOtherDreamFactoryALL}\n\]|" ${FileDreamFactoryShareCodes}
}

## 替换东东工厂互助码
function Change_JdFactoryShareCodes {
  ForOtherJdFactoryALL=""
  echo -e "${FileJdFactoryShareCodes}: 替换东东工厂互助码...\n"
  i=1
  while [ ${i} -le ${UserSum} ]
  do
    TmpJF=ForOtherJdFactory${i}
    eval ForOtherJdFactoryTemp=$(echo \$${TmpJF})
    ForOtherJdFactoryALL="${ForOtherJdFactoryALL}\\n  '${ForOtherJdFactoryTemp}',"
    let i++
  done
  perl -0777 -i -pe "s|(let shareCodes = )\[\n(.+\n?){2}\]|\1\[${ForOtherJdFactoryALL}\n\]|" ${FileJdFactoryShareCodes}
}

## 修改东东超市蓝币兑换数量或实物
function Change_coinToBeans {
  if [ -n "coinToBeans" ]; then
    expr ${coinToBeans} "+" 10 &>/dev/null
    if [ $? -eq 0 ]
    then
      case ${coinToBeans} in
        [1-9] | 1[0-9] | 20 | 1000)
          echo -e "${FileBlueCoin}: 设置东东超市蓝币兑换 ${coinToBeans} 个京豆...\n"
          perl -i -pe "s|let coinToBeans = .+;|let coinToBeans = ${coinToBeans};|" ${FileBlueCoin}
          ;;
        0)
          echo -e "${FileBlueCoin}: 设置东东超市不自动兑换蓝币...\n"
          perl -i -pe "s|let coinToBeans = .+;|let coinToBeans = ${coinToBeans};|" ${FileBlueCoin}
          ;;
      esac
    else
      echo -e "${FileBlueCoin}: 设置东东超市蓝币兑换实物奖品 \"${coinToBeans}\"，该奖品是否可兑换以js运行日志为准...\n"
      perl -i -pe "s|let coinToBeans = .+;|let coinToBeans = \'${coinToBeans}\';|" ${FileBlueCoin}
    fi
  fi
}

## 修改东东超市蓝币成功兑换奖品是否静默运行
function Change_NotifyBlueCoin {
  if [ "${NotifyBlueCoin}" = "true" ]  || [ "${NotifyBlueCoin}" = "false" ]; then
    echo -e "${FileBlueCoin}：设置东东超市成功兑换蓝币是否静默运行为 ${NotifyBlueCoin}...\n"
    perl -i -pe "s|let jdNotify = .+;|let jdNotify = ${NotifyBlueCoin};|" ${FileBlueCoin}
  fi
}

## 修改东东超市是否自动升级商品和货架
function Change_superMarketUpgrade {
  if [ "${superMarketUpgrade}" = "false" ]  || [ "${superMarketUpgrade}" = "true" ]; then
    echo -e "${FileSuperMarket}：设置东东超市是否自动升级商品和货架为 ${superMarketUpgrade}...\n"
    perl -i -pe "s|let superMarketUpgrade = .+;|let superMarketUpgrade = ${superMarketUpgrade};|" ${FileSuperMarket}
  fi
}

## 修改东东超市是否自动更换商圈
function Change_businessCircleJump {
  if [ "${businessCircleJump}" = "false" ] || [ "${businessCircleJump}" = "true" ]; then
    echo -e "${FileSuperMarket}：设置东东超市在小于对方300热力值时是否自动更换商圈为 ${businessCircleJump}\n"
    perl -i -pe "s|let businessCircleJump = .+;|let businessCircleJump = ${businessCircleJump};|" ${FileSuperMarket}
  fi
}

## 修改东东超市是否自动使用金币去抽奖
function Change_drawLotteryFlag {
  if [ "${drawLotteryFlag}" = "true" ] || [ "${drawLotteryFlag}" = "false" ]; then
    echo -e "${FileSuperMarket}：设置东东超市是否自动使用金币去抽奖为 ${drawLotteryFlag}...\n"
    perl -i -pe "s|let drawLotteryFlag = .+;|let drawLotteryFlag = ${drawLotteryFlag};|" ${FileSuperMarket}
  fi
}

## 修改东东农场是否静默运行
function Change_NotifyFruit {
  if [ "${NotifyFruit}" = "true" ] || [ "${NotifyFruit}" = "false" ]; then
    echo -e "${FileFruit}：设置东东农场是否静默运行为 ${NotifyFruit}...\n"
    perl -i -pe "s|let jdNotify = .+;|let jdNotify = ${NotifyFruit};|" ${FileFruit}
  fi
}

## 修改东东农场是否使用水滴换豆卡
function Change_jdFruitBeanCard {
  if [ "${jdFruitBeanCard}" = "true" ] || [ "${jdFruitBeanCard}" = "false" ]; then
    echo -e "${FileFruit}：设置东东农场在出现限时活动时是否使用水滴换豆卡为 ${jdFruitBeanCard}...\n"
    perl -i -pe "s|let jdFruitBeanCard = .+;|let jdFruitBeanCard = ${jdFruitBeanCard};|" ${FileFruit}
  fi
}

## 修改宠汪汪喂食克数
function Change_joyFeedCount {
  case ${joyFeedCount} in
    [1248]0)
      echo -e "${FileJoy}: 设置宠汪汪喂食克数为：${joyFeedCount}g...\n"
      echo -e "${FileJoyFeed}: 设置宠汪汪喂食克数为：${joyFeedCount}g...\n"
      perl -i -pe "s|let FEED_NUM = .+;|let FEED_NUM = ${joyFeedCount};|" ${FileJoy} ${FileJoyFeed}
      ;;
  esac
}

## 修改宠汪汪兑换京豆数量
function Change_joyRewardName {
  case ${joyRewardName} in
    0)
      echo -e "${FileJoyReward}：禁用宠汪汪自动兑换京豆...\n"
      perl -i -pe "s|let joyRewardName = .+;|let joyRewardName = ${joyRewardName};|" ${FileJoyReward}
      ;;
    20 | 500 | 1000)
      echo -e "${FileJoyReward}：设置宠汪汪兑换京豆数量为 ${joyRewardName}...\n"
      perl -i -pe "s|let joyRewardName = .+;|let joyRewardName = ${joyRewardName};|" ${FileJoyReward}
      ;;
  esac
}

## 修改宠汪汪兑换京豆是否静默运行
function Change_NotifyJoyReward {
  if [ "${NotifyJoyReward}" = "true" ] || [ "${NotifyJoyReward}" = "false" ]; then
    echo -e "${FileJoyReward}：设置宠汪汪兑换京豆是否静默运行为 ${NotifyJoyReward}...\n"
    perl -i -pe "s|let jdNotify = .+;|let jdNotify = ${NotifyJoyReward};|" ${FileJoyReward}
  fi
}

## 修改宠汪汪偷取好友积分与狗粮是否静默运行
function Change_NotifyJoySteal {
  if [ "${NotifyJoySteal}" = "true" ] || [ "${NotifyJoySteal}" = "false" ]; then
    echo -e "${FileJoySteal}：设置宠汪汪成功偷取好友积分与狗粮是否静默运行为 ${NotifyJoySteal}...\n"
    perl -i -pe "s|let jdNotify = .+;|let jdNotify = ${NotifyJoySteal};|" ${FileJoySteal}
  fi
}

## 修改宠汪汪是否静默运行
function Change_NotifyJoy {
  if [ "${NotifyJoy}" = "false" ] || [ "${NotifyJoy}" = "true" ]; then
    echo -e "${FileJoy}：设置宠汪汪是否静默运行为 ${NotifyJoy}...\n"
    perl -i -pe "s|let jdNotify = .+;|let jdNotify = ${NotifyJoy};|" ${FileJoy}
  fi
}

## 修改宠汪汪是否自动报名宠物赛跑
function Change_joyRunFlag {
  if [ "${joyRunFlag}" = "false" ] || [ "${joyRunFlag}" = "true" ]; then
    echo -e "${FileJoy}：设置宠汪汪是否自动报名宠物赛跑为 ${joyRunFlag}...\n"
    perl -i -pe "s|let joyRunFlag = .+;|let joyRunFlag = ${joyRunFlag};|" ${FileJoy}
  fi
}

## 修改宠汪汪参加比赛类型
function Change_teamLevel {
  if [ -n "${teamLevel}" ]; then
    echo -e "${FileJoy}：设置宠汪汪参加比赛类型为 ${teamLevel}...\n"
    perl -i -pe "s|let teamLevel = .+;|let teamLevel = \'${teamLevel}\';|" ${FileJoy}
  fi
}

## 修改宠汪汪是否自动给好友的汪汪喂食
function Change_jdJoyHelpFeed {
  if [ "${jdJoyHelpFeed}" = "true" ] || [ "${jdJoyHelpFeed}" = "false" ]; then
    echo -e "${FileJoySteal}：设置宠汪汪是否自动给好友的汪汪喂食为 ${jdJoyHelpFeed}...\n"
    perl -i -pe "s|let jdJoyHelpFeed = .+;|let jdJoyHelpFeed = ${jdJoyHelpFeed};|" ${FileJoySteal}
  fi
}

## 修改宠汪汪是否自动偷好友积分与狗粮
function Change_jdJoyStealCoin {
  if [ "${jdJoyStealCoin}" = "false" ] || [ "${jdJoyStealCoin}" = "true" ]; then
    echo -e "${FileJoySteal}：设置宠汪汪是否自动偷好友积分与狗粮为 ${jdJoyStealCoin}...\n"
    perl -i -pe "s|let jdJoyStealCoin = .+;|let jdJoyStealCoin = ${jdJoyStealCoin};|" ${FileJoySteal}
  fi
}

## 修改摇钱树是否静默运行
function Change_NotifyMoneyTree {
  if [ "${NotifyMoneyTree}" = "false" ] || [ "${NotifyMoneyTree}" = "true" ]; then
    echo -e "${FileMoneyTree}：设置摇钱树是否静默运行为 ${NotifyMoneyTree}...\n"
    perl -i -pe "s|let jdNotify = .+;|let jdNotify = ${NotifyJoy};|" ${FileMoneyTree}
  fi
}

## 修改摇钱树是否自动将金果卖出变成金币
function Change_MoneyTreeAutoSell {
  if [ "${MoneyTreeAutoSell}" = "true" ] || [ "${MoneyTreeAutoSell}" = "false" ]; then
    echo -e "${FileMoneyTree}：设置摇钱树是否自动将金果卖出变成金币为 ${MoneyTreeAutoSell}...\n"
    perl -i -pe "s|(let sellFruit = )\w+;?|\1${MoneyTreeAutoSell};|" ${FileMoneyTree}
  fi
}

## 修改东东萌宠是否静默运行
function Change_NotifyPet {
  if [ "${NotifyPet}" = "true" ] || [ "${NotifyPet}" = "false" ]; then
    echo -e "${FilePet}：设置东东萌宠是否静默运行为 ${NotifyPet}...\n"
    perl -i -pe "s|let jdNotify = .+;|let jdNotify = ${NotifyPet};|" ${FilePet}
  fi
}

## 修改京喜工厂是否静默运行
function Change_NotifyDreamFactory {
  if [ "${NotifyDreamFactory}" = "false" ] || [ "${NotifyDreamFactory}" = "true" ]; then
    echo -e "${FileDreamFactory}：设置京喜工厂是否静默运行为 ${NotifyDreamFactory}...\n"
    perl -i -pe "s|let jdNotify = .+;|let jdNotify = ${NotifyDreamFactory};|" ${FileDreamFactory}
  fi
}

## 修改东东工厂是否静默运行
function Change_NotifyJdFactory {
  if [ "${NotifyJdFactory}" = "false" ] || [ "${NotifyJdFactory}" = "true" ]; then
    echo -e "${FileJdFactory}：设置东东工厂是否静默运行为 ${NotifyJdFactory}...\n"
    perl -i -pe "s|let jdNotify = .+;|let jdNotify = ${NotifyJdFactory};|" ${FileJdFactory}
  fi
}

## 修改东东工厂心仪的商品
function Change_WantProduct {
  if [ -n "${WantProduct}" ]; then
    echo -e "${FileJdFactory}：设置东东工厂心仪商品为 \"${WantProduct}\"...\n"
    perl -i -pe "s|(let wantProduct = ).+;|\1\'${WantProduct}\';|" ${FileJdFactory}
  fi
}

## 修改取关参数
function Change_Unsubscribe {
  if [ ${goodPageSize} ] && [ ${goodPageSize} -gt 0 ]; then
    echo -e "${FileUnsubscribe}：设置商品取关数量为 ${goodPageSize}...\n"
    perl -i -pe "s|let goodPageSize = .+;|let goodPageSize = ${goodPageSize};|" ${FileUnsubscribe}
  fi
  if [ ${shopPageSize} ] && [ ${shopPageSize} -gt 0 ]; then
    echo -e "${FileUnsubscribe}：设置店铺取关数量为 ${shopPageSize}...\n"
    perl -i -pe "s|let shopPageSize = .+;|let shopPageSize = ${shopPageSize};|" ${FileUnsubscribe}
  fi
  if [ ${jdUnsubscribeStopGoods} ]; then
    echo -e "${FileUnsubscribe}：设置禁止取关商品的截止关键字为 ${jdUnsubscribeStopGoods}，遇到此商品不再取关此商品以及它后面的商品...\n"
    perl -i -pe "s|let stopGoods = .+;|let stopGoods = \'${jdUnsubscribeStopGoods}\';|" ${FileUnsubscribe}
  fi
  if [ ${jdUnsubscribeStopShop} ]; then
    echo -e "${FileUnsubscribe}：设置禁止取关店铺的截止关键字为 ${jdUnsubscribeStopShop}，遇到此店铺不再取关此店铺以及它后面的店铺...\n"
    perl -i -pe "s|let stopShop = .+;|let stopShop = \'${jdUnsubscribeStopShop}\';|" ${FileUnsubscribe}
  fi
}

## 修改手机狂欢城是否发送上车提醒
function Change_Notify818 {
  if [ "${Notify818}" = "true" ] || [ "${Notify818}" = "false" ]; then
    echo -e "${File818}：设置手机狂欢城是否发送上车提醒为 ${Notify818}...\n"
    perl -i -pe "s|let jdNotify = .+;|let jdNotify = ${Notify818};|" ${File818}
  fi
}

## 把git_pull.sh中提供的所有账户的PIN附加在jd_joy_run中，让各账户相互进行宠汪汪赛跑助力
## 你的账号将按Cookie顺序被优先助力，助力完成再助力我的账号和lxk0301大佬的账号
function Change_JoyRunPins {
  j=${UserSum}
  PinALL=""
  while [ ${j} -ge 1 ]
  do
    TmpCK=Cookie${j}
    eval CookieTemp=$(echo \$${TmpCK})
    PinTemp=$(echo ${CookieTemp} | perl -pe "{s|.*pt_pin=(.+);|\1|;s|%|\\\x|g}")
    PinTempFormat=$(printf ${PinTemp})
    PinALL="${PinTempFormat},${PinALL}"
    let j--
  done
  PinEvine="Evine,做一颗潇洒的蛋蛋,jd_7bb2be8dbd65c,jd_664ecc3b78945,277548856_m,米大眼老鼠,jd_6dc4f1ed66423,梦回马拉多纳,"
  FriendsArrEvine='"Evine", "做一颗潇洒的蛋蛋", "jd_7bb2be8dbd65c", "jd_664ecc3b78945", "277548856_m", "米大眼老鼠", "jd_6dc4f1ed66423", "梦回马拉多纳", '
  PinALL="${PinALL}${PinEvine}"
  perl -i -pe "{s|(let invite_pins = \[\")(.+\"\];?)|\1${PinALL}\2|; s|(let run_pins = \[\")(.+\"\];?)|\1${PinALL}\2|; s|(const friendsArr = \[)|\1${FriendsArrEvine}|}" ${FileJoyRun}
}

## 将我的invitecode加到脚本中
function Change_InviteCode {
  CodeHealth="'P04z54XCjVUnoaW5kBOUT6t\@P04z54XCjVUnoaW5uC5orRwbaXYMmbp8xnMhfqynp9iHqsxyg', 'P04z54XCjVUnoaW5m9cZ2b-2SkZxn-5OEbVdwM\@P04z54XCjVUnoaW5jcPD2X81XRPkzNn', 'P04z54XCjVUnoaW5m9cZ2asjngclP6bwGQx-n4\@P04z54XCjVUnoaW5uOanrVTc6XTCbVCmoLyWhx9og'"
  CodeZz="  'AfnMPwfg\@A3oT8SyUgFKev3u1PC_joQpaQqr6bl8E8\@AUWE5mauUmGZbCzL_1XVOkA\@ACTJRmqmYxTAOZz0\@AUWE5mfnDyWMJXTT-23hIlg\@A3afASgY-FKyU3ttBCOjgQkn4\@A3LTVSjkHGpmE0NBJBPDa',"
  perl -i -pe "s|(const inviteCodes = \[).*(\];?)|\1${CodeHealth}\2|" jd_health.js
  perl -0777 -i -pe "s|(const inviteCodes = \[\n)(.+\n.+\n\])|\1${CodeZz}\n\2|" jd_jdzz.js
}

## 修改lxk0301大佬js文件的函数汇总
function Change_ALL {
  Change_Cookie
  Change_Token
  Change_BeanSignStop
  Change_FruitShareCodes
  Change_PetShareCodes
  Change_PlantBeanShareCodes
  Change_DreamFactoryShareCodes
  Change_JdFactoryShareCodes
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
  Change_teamLevel
  Change_jdJoyHelpFeed
  Change_jdJoyStealCoin
  Change_NotifyMoneyTree
  Change_MoneyTreeAutoSell
  Change_NotifyPet
  Change_NotifyDreamFactory
  Change_NotifyJdFactory
  Change_WantProduct
  Change_Unsubscribe
  # Change_Notify818
  Change_JoyRunPins
  Change_InviteCode
}

## 检测定时任务是否有变化
## 此函数会在Log文件夹下生成四个文件，分别为：
## shell.list   shell文件夹下用来跑js文件的以“jd_”开头的所有 .sh 文件清单（去掉后缀.sh）
## js.list      scripts/docker/crontab_list.sh文件中用来运行js脚本的清单（去掉后缀.js，非运行脚本的不会包括在内）
## js-add.list  如果 scripts/docker/crontab_list.sh 增加了定时任务，这个文件内容将不为空
## js-drop.list 如果 scripts/docker/crontab_list.sh 删除了定时任务，这个文件内容将不为空
function Diff_Cron {
  ls ${ShellDir} | grep -E "^j[dr]_\w+\.sh" | perl -pe "s|\.sh||" > ${ListShell}
  cat ${ScriptsDir}/docker/crontab_list.sh | grep -E "j[dr]_\w+\.js" | perl -pe "s|.+(j[dr]_\w+)\.js.+|\1|" | sort > ${ListJs}
  grep -vwf ${ListShell} ${ListJs} > ${ListJsAdd}
  grep -vwf ${ListJs} ${ListShell} > ${ListJsDrop}
}

## 设置环境变量：每日签到的通知形式
## 要在检测并增删定时任务以后再运行
function Set_NotifyBeanSign {
  case ${NotifyBeanSign} in
    0)
      echo -e "设置每日签到的通知形式为 关闭通知，仅在运行 shell 脚本时有效，直接运行 js 脚本无效...\n"
      for file in ${ListShellDir}
      do
        perl -i -pe "s|^.*(export JD_BEAN_SIGN_STOP_NOTIFY=).*$|\1true|" ${file}
        perl -i -pe "s|^.*(export JD_BEAN_SIGN_NOTIFY_SIMPLE=).*$|# \1|" ${file}
      done
      ;;
    1)
      echo -e "设置每日签到的通知形式为 简洁通知，仅在运行 shell 脚本时有效，直接运行 js 脚本无效...\n"
      for file in ${ListShellDir}
      do
        perl -i -pe "s|^.*(export JD_BEAN_SIGN_STOP_NOTIFY=).*$|# \1|" ${file}
        perl -i -pe "s|^.*(export JD_BEAN_SIGN_NOTIFY_SIMPLE=).*$|\1true|" ${file}
      done
      ;;
    *)
      echo -e "每日签到的通知形式保持默认为 原始通知...\n"
      for file in ${ListShellDir}
      do
        perl -i -pe "s|^.*(export JD_BEAN_SIGN_STOP_NOTIFY=).*$|# \1|" ${file}
        perl -i -pe "s|^.*(export JD_BEAN_SIGN_NOTIFY_SIMPLE=).*$|# \1|" ${file}
      done
      ;;
  esac
}

## 设置环境变量：User-Agent
## 要在检测并增删定时任务以后再运行
function Set_UserAgent {
  if [ -n "${UserAgent}" ]
  then
    echo -e "设置User-Agent为 \"${UserAgent}\"\n\n仅在运行 shell 脚本时有效，直接运行 js 脚本无效...\n"
    for file in ${ListShellDir}
    do
      perl -i -pe "s<.*(export JD_USER_AGENT=).*$><\1\"${UserAgent}\">" ${file}
    done
  else
    for file in ${ListShellDir}
    do
      perl -i -pe "s<.*(export JD_USER_AGENT=).*$><# \1>" ${file}
    done
  fi
}

## git更新shell脚本
function Git_PullShell {
  echo -e "更新shell脚本，原地址：${ShellURL}\n"
  git fetch --all
  git reset --hard origin/main
  if [ $? -eq 0 ]
  then
    echo -e "\nshell脚本更新完成...\n"
  else
    echo -e "\nshell脚本更新失败，请检查原因后再次运行git_pull.sh，或等待定时任务自动再次运行git_pull.sh...\n"
  fi
}

## npm install 子程序，判断是否为安卓
function NpmInstallSub {
  if [ -n "${isTermux}" ]
  then
    npm install --no-bin-links || npm install --no-bin-links --registry=https://registry.npm.taobao.org
  else
    npm install || npm install --registry=https://registry.npm.taobao.org
  fi
}

## 调用各函数来修改为设定值
## 仅包括修改 lxk0301 大佬的 js 文件的相关函数，不包括设置临时环境变量
cd ${ScriptsDir}
Detect_VerJdShell
Detect_UserSum
if [ $? -eq 0 ]; then
  PackageListOld=$(cat package.json)
  Git_PullScripts
  GitPullExitStatus=$?
fi

if [ ${GitPullExitStatus} -eq 0 ]
then
  echo -e "js脚本更新完成，开始替换信息，并检测定时任务变化情况...\n"
  Change_ALL
  Diff_Cron
else
  echo -e "js脚本更新失败，请检查原因或再次运行git_pull.sh...\n为保证js脚本在更新失败时能够继续运行，仍然替换信息，但不再检测定时任务是否有变化...\n"
  Change_ALL
fi

## 输出是否有新的定时任务
if [ ${GitPullExitStatus} -eq 0 ] && [ -s ${ListJsAdd} ]; then
  echo -e "检测到有新的定时任务：\n"
  cat ${ListJsAdd}
  echo
fi

## 输出是否有失效的定时任务
if [ ${GitPullExitStatus} -eq 0 ] && [ -s ${ListJsDrop} ]; then
  echo -e "检测到有失效的定时任务：\n"
  cat ${ListJsDrop}
  echo
fi

## 自动删除失效的脚本与定时任务，仅在 AutoDelCron 设置为 true 时生效
## 如果检测到某个定时任务在 scripts/docker/crontab_list.sh 中已删除，那么在本地也删除对应的shell脚本与定时任务
if [ ${GitPullExitStatus} -eq 0 ] && [ "${AutoDelCron}" = "true" ] && [ -s ${ListJsDrop} ] && [ -s ${ListCron} ] && [ -d ${ScriptsDir}/node_modules ]; then
  echo -e "开始尝试自动删除定时任务如下：\n"
  cat ${ListJsDrop}
  echo
  for Cron in $(cat ${ListJsDrop})
  do
    perl -i -ne "{print unless /\/${Cron}\./}" ${ListCron}
    rm -f "${ShellDir}/${Cron}.sh"
  done
  crontab ${ListCron}
  echo -e "成功删除失效的脚本与定时任务，当前的定时任务清单如下：\n\n--------------------------------------------------------------\n"
  crontab -l
  echo -e "\n--------------------------------------------------------------\n"
fi

## 自动增加新的定时任务，仅在 AutoAddCron 设置为 true 时生效
## 如果检测到 scripts/docker/crontab_list.sh 中增加新的定时任务，那么在本地也增加
## 本功能生效时，会自动从 scripts/docker/crontab_list.sh 文件新增加的任务中读取时间，该时间为北京时间
if [ ${GitPullExitStatus} -eq 0 ] && [ "${AutoAddCron}" = "true" ] && [ -s ${ListJsAdd} ] && [ -s ${ListCron} ] && [ -d ${ScriptsDir}/node_modules ]; then
  echo -e "开始尝试自动添加定时任务如下：\n"
  cat ${ListJsAdd}
  echo
  JsAdd=$(cat ${ListJsAdd})
  if [ -f ${FileJdSample} ]
  then
    for Cron in ${JsAdd}
    do
      grep -E "\/${Cron}\." "${ScriptsDir}/docker/crontab_list.sh" | perl -pe "s|(^.+)node /scripts(/j[dr]_\w+)\.js.+|\1${ShellDir}\2\.sh|"  >> ${ListCron}
    done
    if [ $? -eq 0 ]
    then
      for Cron in ${JsAdd}
      do
        cp -fv "${FileJdSample}" "${ShellDir}/${Cron}.sh"
        [ ! -x "${ShellDir}/${Cron}.sh" ] && chmod +x "${ShellDir}/${Cron}.sh"
        echo
      done
      crontab ${ListCron}
      echo -e "成功添加新的定时任务，当前的定时任务清单如下：\n\n--------------------------------------------------------------\n"
      crontab -l
      echo -e "\n--------------------------------------------------------------\n"
    else
      echo -e "添加新的定时任务出错，请手动添加...\n"
    fi
  else
    echo -e "${FileJdSample} 文件不存在，可能是shell脚本克隆不正常...\n未能成功添加新的定时任务，请自行添加...\n"
  fi
fi

## 设置临时环境变量，要在检测并增删定时任务以后运行
## 仅在运行${ShellDir}下的jd_xxx.sh时生效，运行${ScriptsDir}下的jd_xxx.js无效
if [ ${GitPullExitStatus} -eq 0 ]; then
  ListShellDir=$(ls ${ShellDir}/*.* | grep -E "/j[dr]_\w+\.a?sh")
  Set_NotifyBeanSign
  Set_UserAgent
fi

## 额外的js脚本相关程序
[ "${EnableExtraJs}" = "true" ] && echo -e "请将新的git_pull.sh.sample重新配置为git_pull，lxk0301大佬已添加东东工厂脚本，而泡泡大战又没啥用，所以不再提供额外的两个任务了...\n
已经在定时任务中添加了额外脚本任务的用户请注意，请按照教程手动在crontab.list中删除jd_factory和jd_paopao两条定时任务，然后将crontab.list添加到系统定时任务中...\n"

## npm install
if [ ${GitPullExitStatus} -eq 0 ]; then
  cd ${ScriptsDir}
  isTermux=$(echo ${ANDROID_RUNTIME_ROOT})
  if [[ "${PackageListOld}" != "$(cat package.json)" ]]; then
    echo -e "检测到 ${ScriptsDir}/package.json 内容有变化，再次运行 npm install...\n"
    NpmInstallSub
    if [ $? -ne 0 ]; then
      echo -e "\nnpm install 运行不成功，自动删除 ${ScriptsDir}/node_modules 后再次尝试一遍..."
      rm -rf ${ScriptsDir}/node_modules
    fi
    echo
  fi
  if [ ! -d ${ScriptsDir}/node_modules ]; then
    echo -e "运行npm install...\n"
    NpmInstallSub
    if [ $? -ne 0 ]; then
      echo -e "\nnpm install 运行不成功，自动删除 ${ScriptsDir}/node_modules...\n\n请进入 ${ScriptsDir} 目录后手动运行 npm install...\n"
      rm -rf ${ScriptsDir}/node_modules
      exit 1
    fi
  fi
fi

## 更新shell脚本
if [ $? -eq 0 ]; then
  cd ${ShellDir}
  echo -e "--------------------------------------------------------------\n"
  Git_PullShell
fi
