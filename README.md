## 使用背景
- 本shell脚本用来运行[lxk0301/scripts](https://github.com/lxk0301/scripts)中的js脚本，解放双手，自动玩耍京东的各种游戏，主要有：各种签到、东东农场、种豆得豆、天天加速、摇钱树、宠汪汪、东东萌宠、京小超，获取各种小羊毛。
- **如果是对js脚本有使用的上的问题请前往 [lxk0301/scripts](https://github.com/lxk0301/scripts) 提出，这里只解决shell脚本的问题。**
## 适合人群
- 每个月要超出Github Action免费使用时长的；
- 没有水果机的；
- 想要精确控制脚本运行时间的；
- 有nas或者vps等7×24运行设备的；
- 想把Cookies牢牢掌握在自己手上的。
## 部署环境
### docker安装
自行安装好docker，然后创建容器：
```
docker run -dit \
  -v /Host主机上的目录/:/root `#冒号左边请替换为Host主机上的目录` \
  --name jd \
  --restart unless-stopped \
  evinedeng/jd-base:latest
```
### 物理机安装
请安装好`git wget curl nodejs npm`：
```
## debian/ubuntu，以及其他以debian为基础的：
apt install -y git wget curl nodejs npm

## CentOS/RedHat/Fedora等
yum install git wget curl nodejs npm

## openwrt，需要添加官方软件源，如果某个软件包已集成在固件中，则可跳过安装。
## 声明：openwrt环境千差万别，不保证一定可用，需要根据自己的环境也配置，如果openwrt安装了docker，也可以使用docker的方法。
opkg install git wget curl node node-npm
```
## 克隆脚本
### docker安装
1. 第一次运行时，容器会自动克隆好跑JD小游戏的js脚本和shell脚本（如果网络不好，就会花很长时间）。会在映射的`/root`下产生以下三个文件夹。
- `log`: 记录所有日志的文件夹，其中跑js脚本的日志会建立对应名称的子文件夹，并且js脚本日志会以`年-月-日-时-分-秒`的格式命名。
- `scripts`: 从 [lxk0301/scripts](https://github.com/lxk0301/scripts) 克隆的js脚本。
- `shell`: 从 [EvineDeng/jd-base](https://github.com/EvineDeng/jd-base) 克隆的shell脚本。

进入容器环境（以下所有docker部分的命令均需要在进入容器后运行）：
```
docker exec -it jd /bin/sh
```
列出文件：
```
ls /root
```
如果发现没有以上三个文件夹，可以运行以下命令（如果有了就直接到`修改信息`这一步）：
```
# 使用wget
sh -c "$(wget https://raw.githubusercontent.com/EvineDeng/jd-base/main/first_run.sh -O -)"

# 或使用curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/EvineDeng/jd-base/main/first_run.sh)"
```
以上脚本会再次尝试自动克隆js脚本和shell脚本，**如果仍然失败，再考虑以下办法**：
```
cd /root
git clone https://github.com/lxk0301/scripts
git clone https://github.com/EvineDeng/jd-base shell
sh shell/first_run.sh
```
### 物理机安装
先cd至你想存放脚本的路径，假如为`/home/myid/jd`，那么：
```
cd /home/myid/jd

# 使用curl
bash -c "$(curl -fsSL https://raw.githubusercontent.com/EvineDeng/jd-base/main/first_run.sh)"

# 或使用wget
bash -c "$(wget https://raw.githubusercontent.com/EvineDeng/jd-base/main/first_run.sh -O -)"
```
脚本会自动在`/home/myid/jd`下载并创建好文件三个文件夹`log  scripts  shell`，解释见docker一节。
## 修改信息
- docker
```
cd /root/shell
cp git_pull.sh.sample git_pull.sh  #复制git_pull.sh.sample为git_pull.sh
chmod +x *.sh                      #重要：必须赋予.sh脚本可执行权限
nano git_pull.sh                   #编辑git_pull.sh，如果不习惯，请直接使用可视化编辑器编辑这个文件
```
- 物理机，仍然以上面举例的`/home/myid/jd`，后面就默认以docker的目录来举例了，如果是物理机安装请自行修改：
```
cd /home/myid/jd/shell
cp git_pull.sh.sample git_pull.sh  #复制git_pull.sh.sample为git_pull.sh
chmod +x *.sh                      #重要：必须赋予.sh脚本可执行权限
nano git_pull.sh                   #编辑git_pull.sh，如果不习惯，请直接使用可视化编辑器编辑这个文件
```
**注意：**
- 请不要直接修改`git_pull.sh.sample`！而只修改`git_pull.sh`。
- 如果在windows下编辑`git_pull.sh`，请使用 notepad++ 等专业工具，请不要使用记事本。
- `.sh`脚本如果没有可执行权限，定时任务将无法正常运行。
- **如何修改请仔细阅读文件中的注释部分。**
### 1.基本能用的玩法
只修改以下部分：
- 定义用户数量
- 定义Cookie
### 2. 进阶玩法
除`基本能用的玩法`中要修改的以外，再根据你的需要修改以下部分：
- 定义通知TOKEN
- 定义东东农场每个人自己的互助码
- 定义东东农场要为哪些人助力
- 定义东东萌宠每个人自己的互助码
- 定义东东萌宠要为哪些人助力
- 定义种豆得豆每个人自己的互助码
- 定义种豆得豆要为哪些人助力
### 3. 高级玩法
除`基本能用的玩法`和`进阶玩法`中要修改的以外，再根据你的需要修改以下部分：
- 定义是否自动删除失效的脚本与定时任务
- 定义是否自动增加新的本地定时任务
- 定义京小超蓝币兑换数量
- 定义京小超蓝币成功兑换奖品是否静默运行
- 定义京小超是否自动升级商品和货架
- 定义京小超是否自动更换商圈
- 定义京小超是否自动使用金币去抽奖
- 定义东东农场是否静默运行
- 定义东东农场是否使用水滴换豆卡
- 定义宠汪汪喂食克数
- 定义宠汪汪兑换京豆数量
- 定义宠汪汪兑换京豆是否静默运行
- 定义宠汪汪偷取好友积分与狗粮是否静默运行
- 定义宠汪汪是否静默运行
- 定义宠汪汪是否自动给好友的汪汪喂食
- 定义宠汪汪是否自动偷好友积分与狗粮
- 定义宠汪汪是否自动报名宠物赛跑
- 定义手机狂欢城是否发送上车提醒
- 定义取关参数
## 定时任务
完成所有信息修改以后，先检查一下git_pull.sh能否正常运行。
```
cd /root/shell  # 如果是物理机，则为cd /home/myid/jd/shell ，其中/home/myid/jd/为上面假定你设置的路径。
sh git_pull.sh  # 如果是物理机，可替换sh为bash
```
看看js脚本的信息替换是否正常。
```
cd /root/scripts  # 如果是物理机，则为cd /home/myid/jd/scripts ，其中/home/myid/jd/为上面假定你设置的路径，后面不再说明，请自行替换。
git diff          # 按q退出
```
然后复制一份crontab.list到/root目录下。物理机请替换`/root`为自己的目录。
```
cp /root/shell/crontab.list.sample /root/crontab.list
```
编辑定时任务并自己根据你的需要调整，也可以使用其他可视化工具编辑。物理机请替换`/root`为自己的目录，包括`crontab.list`这个文件中的路径。
```
nano /root/crontab.list
```
添加定时任务。物理机请替换`/root`为自己的目录。
``` 
crontab /root/crontab.list
```
**说明：**
- docker环境中`crontab.list`这个文件必须存放在`/root`下。其他地方会影响后续脚本运行。
- docker环境中`/root/log/crond.log`可查看定时任务的运行情况；物理机的crond任务日志一般在`/var/log/`下，不在脚本目录，并且一般可能需要开启日志功能才会有。
- docker环境中，第一条定时任务`/root/shell/git_pull.sh`会自动更新js脚本和shell脚本，并完成Cookie、互助码等信息修改，这个任务本身的日志会存在`/root/log/git_pull.log`中。更新过程不会覆盖掉你已经修改好的`git_pull.sh`文件。物理机类似。
- docker环境中，第二条定时任务`/root/shell/rm_log.sh`用来自动删除旧的js脚本日志，如果你未按下一节`自动删除旧日志`中操作的话，这条定时任务不会生效。物理机类似。
- 当`git_pull.sh`中的`AutoAddCron`设置为`false`时（不自动增加新的定时任务），如何手动添加新增js脚本的定时任务，以docker环境为例：
1. 检查有没有新增脚本：
```
cat /root/log/js-add.list
```
2. 如果上一条命令不为空说明有新的定时任务待添加，把内容记下来，比如有个新增的任务叫为`jd_test`，那么就运行以下命令:
```
cp /root/shell/jd.sh.sample /root/shell/jd_test.sh
```
3. 再次提醒不要忘记赋予可执行权限：
```
chmod +x /root/shell/jd_test.sh
```
4. 编辑crontab.list，并添加进crontab
```
nano /root/crontab.list
crontab /root/crontab.list
```
- 如果想使用自动增加定时任务的功能（`git_pull.sh`中`AutoAddCron`设置为`true`），而又不想手动改crontab，那么建议直接使用UTC时间而不是北京时间，创建docker容器时增加一个环境变量`TZ=UTC`即可，不过crontab任务清单建议你自己也调成UTC时间，创建命令如下：
```
docker run -dit \
  -v /Host主机上的目录/:/root `#冒号左边请替换为Host主机上的目录` \
  -e TZ=UTC \
  --name jd \
  --restart unless-stopped \
  evinedeng/jd-base:latest
```
## 自动删除旧日志
单个日志虽然小，但如果长期运行的话，日志也会占用大量空间，如需要自动删除，请按以下流程操作：
1. 复制一份rm_log.sh，并赋予可执行权限（以docker为例）：
```
cd /root/shell
cp rm_log.sh.sample rm_log.sh
chmod +x rm_log.sh
```
2. 该脚本在运行时默认删除`30天`以前的日志，如果需要设置为其他天数，请修改脚本中的`HowManyDays`。
3. 按`定时任务`部分的说明修改定时任务。
## 补充说明
- 其实`shell`目录下所有以`jd_`开头以`.sh`结尾的文件内容全都一样，全都是从`jd.sh.sample`复制来的，它们是依靠它们自身的文件名来找到所对应的`scripts`目录下的js文件并且执行的。所以，有新的任务时，只要你把`jd.sh.sample`复制一份和新增的`.js`脚本名称一样，赋予可执行权限，再增加定时任务就可以了。
- 如果想要重新调整定时任务运行时间，请不要直接使用`crontab -e`命令修改，而是编辑`/root/crontab.list`(物理机则为一开始确定的位置)这个文件，然后使用`crontab /root/crontab.list`命令覆盖。这样的好处只要你没有删除容器映射目录`/root`在Host主机上的原始文件夹，重建容器时任务就不丢失，并且，如果重建容器，容器还将在启动时自动从`/root/crontab.list`中恢复定时任务。（物理机无法自动重建定时任务，需要手动恢复）
- 如果shell脚本有更新，需要你手动复制一份`git_pull.sh.sample`，并重新修改必须的信息，然后命名为`git_pull.sh`，流程如下（以docker为例）：
```
cd /root/shell
cp git_pull.sh.sample git_pull_2.sh
# 然后修改git_pull_2.sh，也可使用其他可视化工具修改
nano git_pull_2.sh
# 修改好后，替换旧的git_pull.sh
mv git_pull_2.sh git_pull.sh
# 不要忘记赋予修改后的.sh脚本可执行权限
chmod +x git_pull.sh
```
- 如有帮助到你，请点亮 star 。
