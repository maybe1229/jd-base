## 部署环境

请先确认你的平台属于这几种：linux/amd64, linux/arm64, linux/ppc64le, linux/s390x, linux/arm/v7, linux/arm/v6，如不属于则无法使用本方法。

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

## 克隆脚本

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
    
3. docker容器创建后会在容器中的`/root`文件夹下自动克隆好跑JD小游戏的js脚本和shell脚本，产生以下三个文件夹：

    - `log`: 记录所有日志的文件夹，其中跑js脚本的日志会建立对应名称的子文件夹，并且js脚本日志会以`年-月-日-时-分-秒`的格式命名。

    - `scripts`: 从 [lxk0301/jd_scripts](https://github.com/lxk0301/jd_scripts) 克隆的js脚本。

    - `shell`: 从 [EvineDeng/jd-base](https://github.com/EvineDeng/jd-base) 克隆的shell脚本。

## 修改信息

1. 复制`git_pull.sh.sample`为`git_pull.sh`:

    ```
    cp /root/shell/git_pull.sh.sample /root/shell/git_pull.sh  # 
    ```

2. 编辑`git_pull.sh`，容器中中文为乱码，建议Windows用户使用WinSCP工具，以SFTP协议连接机器，前往部署容器时运行的 `-v /Host主机上的目录/:/root` 这个命令中冒号左边的路径下面去找，如何使用WinSCP请自行百度。可定义内容清单：[parameter_change](Parameter.md)

    - *注1：如果在windows下编辑`git_pull.sh`，请使用WinSCP自带编辑器，或 notepad++、VS Code、Sublime Text 3等软件，请不要使用记事本。*

    - *注2：如何修改请仔细阅读文件中的注释部分。*

    - *注3：如果在WinSCP中看不见文件或看见了但不是最新的文件，请点击鼠标右键-刷新来刷新文件清单。*

## 初始化

**在编辑好git_pull.sh这个文件后，请务必手动运行一次git_pull.sh，不仅是为检查错误，也是为了运行一次`npm install`用以安装js指定的依赖。**

1. 完成所有信息修改以后，先检查一下git_pull.sh能否正常运行。

    ```
    cd /root/shell
    chmod +x *.sh
    sh git_pull.sh
    ```

    *注1：`.sh`脚本如果没有可执行权限，虽然手动执行可以运行，但定时任务将无法正常运行。*

    *注2：首次运行的日志很重要，如果过程中有任何错误，请参考错误提示来解决问题。主要包括两类问题：一是无法访问github，请想办法改善网络；二是`git_pull.sh`会运行`npm install`，用来安装js指定的依赖，如果你网络不好，日志中会有提示，请注意观察。如果`npm install`失败，请尝试手动运行，可按如下操作，如果失败，可运行多次：*

    ```
    cd /root/scripts
    npm install || npm install --registry=https://registry.npm.taobao.org
    ```

2. 看看js脚本的信息替换是否正常。

    ```
    cd /root/scripts
    git diff          # 请使用上下左右键、Page Down、Page Up进行浏览，按q退出
    ```

3. 然后你可以手动运行一次任何一个以`jd_`开头并以`.sh`结尾的脚本（有些脚本会运行很长时间，sh本身不输入任何内容在屏幕上，而把日志全部记录在日志文件中）。

    ```
    cd /root/shell
    sh jd_bean_sign.sh
    ```

    去容器中`/root/log/jd_bean_sign`文件夹下查看日志，查看结果是否正常，如不正常，请从头检查。

## 定时任务

1. 复制一份`crontab.list`到`/root`目录下。

    ```
    cp /root/shell/crontab.list.sample /root/crontab.list
    ```

2. 按修改`git_pull.sh`的方法修改`crontab.list`。

3. 添加定时任务。

    ```
    crontab /root/crontab.list
    ```

**说明：**

- `crontab.list`这个文件必须存放在`/root`下，其他地方会影响后续脚本运行。

- `/root/log/crond.log`可查看定时任务的运行情况。

- 第一条定时任务`/root/shell/git_pull.sh`会自动更新js脚本和shell脚本，并完成Cookie、互助码等信息修改，这个任务本身的日志会存在`/root/log/git_pull.log`中。更新过程不会覆盖掉你已经修改好的`git_pull.sh`文件。

- 第二条定时任务`/root/shell/rm_log.sh`用来自动删除旧的js脚本日志，如果你未按下一节`自动删除旧日志`中操作的话，这条定时任务不会生效。

- 当`git_pull.sh`中的`AutoAddCron`设置为`false`时（不自动增加新的定时任务），如何手动添加新增js脚本的定时任务：

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

## 自动删除旧日志

单个日志虽然小，但如果长期运行的话，日志也会占用大量空间，如需要自动删除，请按以下流程操作：

1. 复制一份rm_log.sh，并赋予可执行权限：

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

- 如果想要重新调整定时任务运行时间，请不要直接使用`crontab -e`命令修改，而是编辑`/root/crontab.list`这个文件，然后使用`crontab /root/crontab.list`命令覆盖。这样的好处只要你没有删除容器映射目录`/root`在Host主机上的原始文件夹，重建容器时任务就不丢失，并且，如果重建容器，容器还将在启动时自动从`/root/crontab.list`中恢复定时任务。

- 如果shell脚本有更新，需要你手动复制一份`git_pull.sh.sample`，并重新修改必须的信息，然后命名为`git_pull.sh`，流程如下：
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
