## 所有教程已转移至[WIKI](https://github.com/EvineDeng/jd-base/wiki)。

适用于以下系统：

- ArmBian/Debian/Ubuntu/OpenMediaVault/CentOS/Fedora/RHEL等Linux系统

- OpenWRT

- Android

- MacOS

- Docker

## 更新日志

> 只记录大的更新，小修小改不记录。

- **2020-11-10：lxk0301/scripts 已被封，新的库为 [lxk0301/jd_scripts](https://github.com/lxk0301/jd_scripts)，所有在这时间之前的老用户请按 [#26](https://github.com/EvineDeng/jd-base/issues/26) 重新配置一下！！**

- 2020-11-11：已构建多平台docker镜像，包括：linux/amd64, linux/arm64, linux/ppc64le, linux/s390x, linux/arm/v7, linux/arm/v6。树莓派、N1小钢炮等arm设备均可使用。

- 2020-11-13：重新用Perl语言改写sed命令，脚本已经可以兼容Android、MacOS。

- 2020-11-15：为保持跨平台兼容性，把`Docker`的`shell`也更换为`bash`，Docker用户需要删除原来的镜像重新部署方可正常使用。
    ```shell
    docker stop jd
    docker rm jd 
    docker rmi evinedeng/jd-base
    ```
    无需重新配置，直接按原来的`docker run`命令重新部署即可恢复原有内容。

- 2020-11-20：增加 [799953468](https://github.com/799953468) 大佬开发的脚本，原地址：[799953468/Quantumult-X](https://github.com/799953468/Quantumult-X)，需要按照新的`git_pull.sh.sample`重新配置为`git_pull.sh`方可使用。另外，游戏未开通的需要先开通：京东app首页搜索“边玩边赚”，进去后找“东东工厂”和“泡泡大战”。

- 2020-11-23：增加每日签到接口延迟时间自定义功能；增加每日签到关闭通知和简洁通知的控制开关；增加`User-Agent`自定义功能。如需要使用上述功能，需要按照新的`git_pull.sh.sample`重新配置为`git_pull.sh`方可使用。

- 2020-11-24：1.增加摇钱树是否发送通知的控制开关；2.增加摇钱树是否自动卖出金果的控制开关；3.修改安卓相关代码，现在安卓不root也可以正常在外置存储使用本脚本了。前两项新功能需要按照新的`git_pull.sh.sample`重新配置为`git_pull.sh`方可使用，后一项安卓的新功能需要你在手机上更换路径重新配置，配置后查看日志以及文件更方便了。

## Star趋势

[![Stargazers over time](https://starchart.cc/EvineDeng/jd-base.svg)](https://starchart.cc/EvineDeng/jd-base)
