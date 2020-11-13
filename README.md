## TO DO LIST

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

## 教程

- [Armbian/OpenWrt/Debian/Ubuntu/CentOS/Fedora/RedHat等Linux系统](Readme/Computer.md)

    适用人群：
    - 想要精确控制脚本运行时间的；
    - 有NAS、VPS、软路由、树莓派、N1小钢炮等可7×24运行设备的；
    - 想把Cookies牢牢掌握在自己手上的。

- Android（请等待代码修改完成后再提供教程）

- MacOS（请等待代码修改完成后再提供教程）

- [Docker](Readme/Docker.md)

