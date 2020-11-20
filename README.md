## 所有教程已转移至[WIKI](https://github.com/EvineDeng/jd-base/wiki)。

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

- 2020-11-20：增加 [799953468](https://github.com/799953468) 大佬开发的脚本，原地址：https://github.com/799953468/Quantumult-X，需要按照新的`git_pull.sh.sample`重新配置为`git_pull.sh`方可使用。

## Star趋势

[![Stargazers over time](https://starchart.cc/EvineDeng/jd-base.svg)](https://starchart.cc/EvineDeng/jd-base)
