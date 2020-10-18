## 使用背景
- **必须完整理解 [lxk0301/scripts](https://github.com/lxk0301/scripts) 是做什么的，如果不理解请不要往下看了。**
- **如果是对js脚本有使用的上的问题请前往 [lxk0301/scripts](https://github.com/lxk0301/scripts) 提出，这里只解决shell脚本的问题。**
## 适合人群
- 每个月要超出Github Action免费使用时长的；
- 没有水果机的；
- 想要精确控制脚本运行时间的；
- 有nas或者vps等7×24运行设备的。
## 部署环境
- 自行安装好docker。
- 命令行输入：
```
docker run -dit \
  -v <Host主机上的目录>:/root `#请替换为Host主机上的目录 ` \
  --name jd \
  -restart unless-stopped \
  evinedeng/jd-base:latest
```
## 克隆脚本
第一次运行时，容器会自动克隆好跑JD小游戏的js脚本和shell脚本。会在映射的`/root`下产生以下三个文件夹。
- `log`: 记录所有日志的文件夹，其中跑js脚本的日志会建立对应名称的子文件夹，并且js脚本日志会以`年-月-日-时-分-秒`的格式命名。
- `scripts`: 从 [lxk0301/scripts](https://github.com/lxk0301/scripts) 克隆的js脚本。
- `shell`: 从 [EvineDeng/jd-base](https://github.com/EvineDeng/jd-base) 克隆的shell脚本。

进入容器环境（以下所有命令均需要在进行容器后运行）：
```
docker exec -it jd /bin/sh
```
列出文件：
```
ls /root
```
如果发现没有以上三个文件，可以依次运行：
```
使用wget
sh -c "$(wget https://raw.githubusercontent.com/EvineDeng/jd-base/main/first_run.sh -O -)"
或使用curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/EvineDeng/jd-base/main/first_run.sh)"
```
以上脚本会再次尝试自动克隆js脚本和shell脚本，**如果仍然失败，再考虑以下办法**：
```
cd /root
git clone https://github.com/lxk0301/scripts
git clone https://github.com/EvineDeng/jd-base shell
sh shell/first_run.sh
```
## 修改信息
```
cd /root/shell
cp git_pull.sh.sample git_pull.sh  #复制git_pull.sh.sample为git_pull.sh
nano git_pull.sh #编辑git_pull.sh，如果不习惯，请直接使用可视化编辑器编辑这个文件
```
**注意：**
- 请不要直接修改`git_pull.sh.sample`！而只修改`git_pull.sh`。
- 如果在windows下编辑`git_pull.sh`，请使用 notepad++ 等专业工具，请不要使用记事本。
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
- 定义京小超商圈每个人自己的互助码
- 定义京小超商圈要为哪些人助力
### 3. 高级玩法
除`基本能用的玩法`和`进阶玩法`中要修改的以外，再根据你的需要修改以下部分：
- 定义是否自动删除失效的脚本与定时任务
- 定义是否自动增加新的本地定时任务
- 定义京小超蓝币兑换数量
- 定义京小超蓝币成功兑换奖品是否静默运行
- 定义京小超是否自动升级商品和货架
- 定义京小超是否自动更换商圈
- 定义东东农场是否静默运行
- 定义宠汪汪喂食克数
- 定义宠汪汪兑换京豆是否静默运行
- 定义宠汪汪是否自动给好友的汪汪喂食
- 定义宠汪汪是否自动偷好友积分与狗粮
- 定义宠汪汪是否自动报名宠物赛跑
## 定时任务
完成所有信息修改以后，运行：
```
# 复制一份crontab.list到/root目录下，
cp /root/shell/crontab.list.sample /root/crontab.list
# 编辑定时任务并自己根据你的需要调整，也可以使用其他可视化工具编辑
nano /root/crontab.list 
# 添加定时任务
crontab /root/crontab.list
```
说明：
- `crontab.list`这个文件必须存放在`/root`下，其他地方会影响后续脚本运行。
- 第一条定时任务`/root/shell/git_pull.sh >> /root/log/git_pull.log`会自动更新js脚本和shell脚本，并完成Cookie、互助码等信息修改，这个任务本身的日志会存在` /root/log/git_pull.log`中。更新过程不会覆盖掉你已经修改好的`git_pull.sh`文件。如果shell脚本有更新，需要你手动复制一份`git_pull.sh.sample`，并重新修改必须的信息，然后命名为`git_pull.sh`。
```
cd /root/shell
cp git_pull.sh.sample git_pull_2.sh
# 然后修改git_pull_2.sh，修改好以后再覆盖旧版本的git_pull.sh
mv git_pull_2.sh git_pull.sh
```
## 补充说明
- 暂未添加定时删除旧日志的功能，如果觉得日志文件太大，请自行删除。
- 如果想要重新调整定时任务运行时间，请不要直接使用`crontab -e`命令修改，而是编辑`/root/crontab.list`这个文件，然后使用`crontab /root/crontab.list`命令覆盖。这样的好处只要你没有删除容器映射目录`/root`在Host主机上的原始文件夹，重建容器时任务就不丢失。
