## TO Do LIST

- 重新用Perl语言改写sed命令，使之兼容Android、MacOS。

## 更新日志

    只记录大的更新，小修小改不记录。

- 2020-11-07：将原来的`git_pull.sh.sample`分离成两个文件`git_pull.sh.sample`（更小了）和`git_pull_function.sh`，用户以后只需要按下面教程将`git_pull.sh.sample`复制一份`git_pull.sh`后修改即可，具体的函数全放在`git_pull_function.sh`中，大家不再需要关注脚本函数的变化，并且还可以兼容不愿意升级的老的`git_pull.sh`脚本。

- 2020-11-08：调整jd.sh.sample，无论容器环境是北京时间还是UTC时间，日志文件名均记录为北京时间。**在运行过一次最新的git_pull.sh并重启容器后生效。**

- **2020-11-10：lxk0301/scripts 已被封，新的库为 [lxk0301/jd_scripts](https://github.com/lxk0301/jd_scripts)，所有人请按[#26](https://github.com/EvineDeng/jd-base/issues/26)重新配置一下！！**

- 2020-11-11：已构建多平台docker镜像，包括：linux/amd64, linux/arm64, linux/ppc64le, linux/s390x, linux/arm/v7, linux/arm/v6。树莓派、N1小钢炮等arm设备均可使用。

## 使用背景

- 本shell脚本用来运行[lxk0301/jd_scripts](https://github.com/lxk0301/jd_scripts)中的js脚本，解放双手，自动玩耍京东的各种游戏，主要有：各种签到、东东农场、种豆得豆、天天加速、摇钱树、宠汪汪、东东萌宠、东东超市，获取各种小羊毛。

- 本脚本只是给lxk0301大佬的js脚本套了层壳，建议大家多多关注lxk0301大佬的仓库。

- **如果是对js脚本有使用的上的问题请前往 [lxk0301/jd_scripts](https://github.com/lxk0301/jd_scripts) 提出，这里只解决shell脚本的问题。**

## 适合人群

- 没有水果机的；
- 想要精确控制脚本运行时间的；
- 有NAS、VPS、软路由、树莓派、N1小钢炮等可7×24运行设备的；
- 想把Cookies牢牢掌握在自己手上的。

## 部署环境

### docker安装

安装好docker([中文教程](https://mirrors.bfsu.edu.cn/help/docker-ce/))，然后在ssh工具中创建容器：

```
docker run -dit \
  -v /Host主机上的目录/:/root `#冒号左边请更改为你docker所在主机上的原始路径` \
  --name jd \
  --restart unless-stopped \
  evinedeng/jd-base:latest
```

*注1：只有这里是五行一起复制粘贴的，下面其他的地方均是一行一行复制粘贴。*

*注2：对`-v`这个参数稍微解释一下，冒号前面是主机上的真实路径，冒号后面是虚拟路径，也就是在容器内部看到的路径，这个参数就是把冒号左边的真实路径映射为容器内冒号右边的虚拟路径。*

*注3：如需多账号并发，请配置多个容器。*

### 物理机安装

请根据系统的不同，安装好`git wget curl nodejs npm`。

- debian/ubuntu/armbian，以及其他debian系：
    ```
    apt update && apt install -y git wget curl nodejs npm
    ```
- CentOS/RedHat/Fedora等红帽系
    ```
    yum update && yum install git wget curl nodejs npm
    ```
- OpenWrt， **需要添加官方软件源，** 如果某个软件包已集成在固件中，则可跳过安装。如果你会编译，可以把下面这些包直接编译在固件中。
    ```
    opkg update && opkg install git git-http wget curl node node-npm
    ```
    **声明：OpenWrt环境千差万别，不保证一定可用，需要根据自己的环境来配置，如果OpenWrt安装了docker，也可以使用docker的方法。**

*注1：不同系统的包名不一定一样，需保证 node 大版本 >=10，安装好后使用`node -v`或`nodejs -v`命令可查看版本。*

*注2：如果是按以上命令安装成功，那应该没问题。如果是nvm安装的或其他方式安装的，请确保安装后的命令在 PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" 中，如不在，请参考[#21](https://github.com/EvineDeng/jd-base/issues/21)修改。*

## 克隆脚本

docker和物理机分别按下述方法执行之后，指定的路径（docker固定在容器内的`/root`下，物理机由你指定）会自动克隆好跑JD小游戏的js脚本和shell脚本，产生以下三个文件夹：

- `log`: 记录所有日志的文件夹，其中跑js脚本的日志会建立对应名称的子文件夹，并且js脚本日志会以`年-月-日-时-分-秒`的格式命名。

- `scripts`: 从 [lxk0301/jd_scripts](https://github.com/lxk0301/jd_scripts) 克隆的js脚本。

- `shell`: 从 [EvineDeng/jd-base](https://github.com/EvineDeng/jd-base) 克隆的shell脚本。

### docker安装

1. 检查容器安装日志

    ```
    docker logs -f jd
    ```

    *注1：检查日志输出是否正常，如果是首次运行，那么最后一条输出将出现 `脚本执行成功，请按照 Readme 教程继续配置...` 在出现此消息后可按`CTRL + C`切出来。*

    *注2：如没有成功，请根据错误提示进行操作。如果啥中文提示都没有，那么是你网络不好，无法连接Github，请想办法改善。*
    
2. 确保出现上述成功的消息后，进入容器环境：

    **本Readme中所有docker部分的命令均需要在进入容器后运行！！**

    **本Readme中所有docker部分的命令均需要在进入容器后运行！！**

    **本Readme中所有docker部分的命令均需要在进入容器后运行！！**

    ```
    docker exec -it jd /bin/sh
    ```
    成功进入后光标处应变为下面这样，如果没有，那么请检查容器安装日志。
    ```
    ~ # 
    ```

### 物理机安装

先cd至你想存放脚本的路径，假如为`/home/myid/jd`，那么：

```
cd /home/myid/jd

# 使用curl
bash -c "$(curl -fsSL https://raw.githubusercontent.com/EvineDeng/jd-base/main/first_run.sh)"

# 或者使用wget
bash -c "$(wget https://raw.githubusercontent.com/EvineDeng/jd-base/main/first_run.sh -O -)"
```

*注：物理机如需多账号并发，需要创建多个文件夹，然后分别进入每个文件夹后运行上述命令，然后在每个创建的文件夹下都按下面说明配置一下，并且在制定定时任务时，你配置了多少个文件夹，那么同一条定时任务就要重复几次（因为.sh脚本路径不一样）。*

## 修改信息

- docker安装

    ```
    cd /root/shell
    cp git_pull.sh.sample git_pull.sh  # 复制git_pull.sh.sample为git_pull.sh
    nano git_pull.sh                   # 编辑git_pull.sh，容器中中文为乱码，建议直接导出来在外部使用可视化编辑器编辑这个文件后上传进去
    ```
    
- 物理机安装

    仍然以上面举例的`/home/myid/jd`，后面就默认以docker的目录来举例了，如果是物理机安装请自行修改：

    ```
    cd /home/myid/jd/shell
    cp git_pull.sh.sample git_pull.sh  # 复制git_pull.sh.sample为git_pull.sh
    nano git_pull.sh                   # 编辑git_pull.sh，如果不习惯，请直接使用可视化编辑器编辑这个文件
    ```

**注意：**

- *请不要直接修改`git_pull.sh.sample`！而只修改`git_pull.sh`。*

- *Windows用户可以使用WinSCP这个软件，连接机器找对应文件（docker安装的请前往部署容器时运行的 `-v /Host主机上的目录/:/root` 这个命令中冒号左边的路径去找；物理机安装的就是你定义的那个路径。）如何使用WinSCP请自行百度。*

- *如果在windows下编辑`git_pull.sh`，请使用 notepad++、VS Code、Sublime Text 3等软件，请不要使用记事本。*

- **如何修改请仔细阅读文件中的注释部分。**

### 1.基本能用的玩法

只修改以下部分（**这两个也是必须修改的内容**）：

- 定义用户数量
- 定义Cookie

### 2. 进阶玩法

除`基本能用的玩法`中要修改的以外，再根据你的需要修改以下部分（均为选填）：

- 定义通知TOKEN
- 定义东东农场每个人自己的互助码
- 定义东东农场要为哪些人助力
- 定义东东萌宠每个人自己的互助码
- 定义东东萌宠要为哪些人助力
- 定义种豆得豆每个人自己的互助码
- 定义种豆得豆要为哪些人助力

### 3. 高级玩法

除`基本能用的玩法`和`进阶玩法`中要修改的以外，再根据你的需要修改以下部分（均为选填）：

- 定义是否自动删除失效的脚本与定时任务
- 定义是否自动增加新的本地定时任务
- 定义东东超市蓝币兑换数量
- 定义东东超市蓝币成功兑换奖品是否静默运行
- 定义东东超市是否自动升级商品和货架
- 定义东东超市是否自动更换商圈
- 定义东东超市是否自动使用金币去抽奖
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

## 初始化

**在编辑好git_pull.sh这个文件后无论是docker运行，还是物理机运行，请务必手动运行一次git_pull.sh，不仅是为检查错误，也是为了运行一次`npm install`用以安装js指定的依赖。**

1. 完成所有信息修改以后，先检查一下git_pull.sh能否正常运行。

    ```
    cd /root/shell  # 如果是物理机，则为cd /home/myid/jd/shell ，其中/home/myid/jd/为上面假定你设置的路径。
    chmod +x *.sh   # 重要：必须赋予.sh脚本可执行权限
    sh git_pull.sh  # 如果是物理机，请按下面说明修改
    ```

    *注1：如果是物理机，请先使用`echo $SHELL`命令查看自己的shell，如果返回的是`/bin/bash`，那么可以替换`sh git_pull.sh`命令为`bash git_pull.sh`。*
    
    *注2：`.sh`脚本如果没有可执行权限，虽然手动执行可以运行，但定时任务将无法正常运行。*

    *注3：首次运行的日志很重要，如果过程中有任何错误，请参考错误提示来解决问题。主要包括两类问题：一是无法访问github，请想办法改善网络；二是git_pull.sh会运行npm install，用来安装js指定的依赖，如果你网络不好，日志中会有提示，请注意观察。如果npm install失败，请尝试手动运行，比如容器可按如下操作：*

    ```
    cd /root/scripts
    npm install
    ```

2. 看看js脚本的信息替换是否正常。

    ```
    cd /root/scripts  # 如果是物理机，则为cd /home/myid/jd/scripts ，其中/home/myid/jd/为上面假定你设置的路径，后面不再说明，请自行替换。
    git diff          # 请使用上下左右键、Page Down、Page Up进行浏览，按q退出
    ```

3. 然后你可以手动运行一次任何一个以`jd_`开头并以`.sh`结尾的脚本（有些脚本会运行很长时间，sh本身不输入任何内容在屏幕上，而把日志全部记录在日志文件中）。

    ```
    cd /root/shell      # 物理机请修改为自己的路径
    sh jd_bean_sign.sh  # 物理机参考本节第1.步替换sh命令
    ```

    去`log/jd_bean_sign`文件夹下查看日志，查看结果是否正常，如不正常，请从头检查。

## 定时任务

1. 然后复制一份`crontab.list`到`/root`目录下。物理机请替换`/root`为自己一开始设置的目录。

    ```
    cp /root/shell/crontab.list.sample /root/crontab.list
    ```

2. 编辑定时任务并自己根据你的需要调整，也可以使用其他可视化工具编辑。物理机请替换`/root`为自己一开始设置的目录，包括`crontab.list`这个文件定时任务中的路径。

    ```
    nano /root/crontab.list
    ```

3. 添加定时任务。
    **物理机请注意：1.请替换`/root`为自己一开始设置的目录；2.以下命令会完整覆盖你当前用户的crontab清单，请务必确认当前用户不存在其他定时任务！！。**

    ```
    crontab /root/crontab.list
    ```

**说明：**

- **docker**环境中`crontab.list`这个文件必须存放在`/root`下，其他地方会影响后续脚本运行；**物理机**则必须存在于一开始你确定的目录的，如上述举例时的`/home/myid/jd`。

- **docker**环境中`/root/log/crond.log`可查看定时任务的运行情况；**物理机**的crond任务日志一般在`/var/log/`下，不在脚本目录，并且一般可能需要开启日志功能才会有。

- **docker**环境中，第一条定时任务`/root/shell/git_pull.sh`会自动更新js脚本和shell脚本，并完成Cookie、互助码等信息修改，这个任务本身的日志会存在`/root/log/git_pull.log`中。更新过程不会覆盖掉你已经修改好的`git_pull.sh`文件。**物理机**类似。

- **docker**环境中，第二条定时任务`/root/shell/rm_log.sh`用来自动删除旧的js脚本日志，如果你未按下一节`自动删除旧日志`中操作的话，这条定时任务不会生效。**物理机**类似。

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

- **物理机**如果想使用自动增加定时任务的功能（`git_pull.sh`中`AutoAddCron`设置为`true`），而又不想手动改crontab，那么你的机子必须是北京时间，使用`date`命令可以查看系统时间。

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

## 退出容器

如果是Docker安装的，请在配置完成以后退出容器环境：

```
exit
```

## 补充说明

- 其实`shell`目录下所有以`jd_`开头以`.sh`结尾的文件内容全都一样，全都是从`jd.sh.sample`复制来的，它们是依靠它们自身的文件名来找到所对应的`scripts`目录下的js文件并且执行的。所以，有新的任务时，只要你把`jd.sh.sample`复制一份和新增的`.js`脚本名称一样，赋予可执行权限，再增加定时任务就可以了。

- 如果想要重新调整定时任务运行时间，请不要直接使用`crontab -e`命令修改，而是编辑`/root/crontab.list`（物理机则为一开始设置的目录下）这个文件，然后使用`crontab /root/crontab.list`命令覆盖。这样的好处只要你没有删除容器映射目录`/root`在Host主机上的原始文件夹，重建容器时任务就不丢失，并且，如果重建容器，容器还将在启动时自动从`/root/crontab.list`中恢复定时任务。（针对物理机，为防止破坏本身存在的定时任务，脚本已设置不自动重建定时任务，需要手动恢复。）

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

- 向经常关注本脚本并且知道何为助力上车的人提供一个自动上车脚本`create_share_codes.sh.sample`，请自行参考上述`git_pull.sh`的修改方法修改为`create_share_codes.sh`，并修改其中必要的信息。在理解[这个链接](http://api.turinglabs.net/api/v1/jd/cleantimeinfo/)的含义之后自行添加定时任务，**有关于此的提问一概不回复，不解释**。

- 如有帮助到你，请点亮 star 。
