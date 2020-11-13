## 申明申明申明申明申明申明申明申明申明申明申明

1. **经测试，受到手机电量管理策略的影响，安卓下的定时任务似乎有点抽风，有时候能准时运行，有时候又不能准时运行。**

2. **如果被手机杀掉了进程，那么所有定时任务都不会执行了。**

3. **每次重启手机或重启`Termux`后需要重新手动启动crond程序。**

4. **建议安卓运行脚本只做为其他脚本运行方式的一种补充，比如在有类似家电星推官时，可以在手机上运行以达到`手动准时运行`的效果。**

## 准备工作

1. 想办法安装好谷歌服务框架，注意：需要科学上网条件。

2. 从谷歌商店搜索并安装 `Termux`。

3. 从[这里](https://www.sqlsec.com/2018/05/termux.html)学习 `Termux` 的基础用法，这其中介绍的 `termux-ohmyzsh` 一定要装，能显著减少手机上的输入活动。另外，也建议按照该教程进行：切换为国内源、美化终端、允许访问手机外置存储等操作，其他部分也建议多看多学。

## 安装依赖

切换为国内安装源后，在`Termux`中输入：
```
pkg upgrade
pkg install git perl nodejs-lts wget curl nano cronie
```

## 下载脚本

- **前提：**

    `Termux`的家目录为：`/data/data/com.termux/files/home`，一般家目录用`~`这个符号代替，这个家目录位于手机的内置存储中。

    按照上面`Termux`教程中允许访问手机外置存储的操作后，家目录下会有一个`storage`的软连接，连接的是手机的外置存储。

    在手机没有进行root的情况下，一般的文件管理器仅能查看外置存储的文件，无法查看内置存储的文件。

    **经测试，本脚本只能在内置存储中运行，在外置存储中无法正常运行。**

- **脚本下载：**

    1. 在家目录下创建一个用于存放脚本的文件夹：
        ```
        mkdir jd
        ```
    2. 进入刚创建好的文件夹：
        ```
        cd jd
        ```
    3. 一键下载并运行脚本（可能需要科学上网条件）：
        ```
        # 使用curl
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/EvineDeng/jd-base/main/first_run.sh)"

        # 或者使用wget
        bash -c "$(wget https://raw.githubusercontent.com/EvineDeng/jd-base/main/first_run.sh -O -)"
        ```
        如果实在下载不下来，建议去[这个链接](https://raw.githubusercontent.com/EvineDeng/jd-base/main/first_run.sh)手动复制，然后粘贴在手机外置存储的一个文件中，并将文件命名为`first_run.sh`。比如你已经将这个文件存放在外置存储的`Download`文件夹中，那么以下命令可以将它复制到家目录中`jd`文件夹下：
        ```
        cp ~/storage/shared/Download/first_run.sh ~/jd/first_run.sh
        ```
        然后手动运行它：
        ```
        bash first_run.sh
        ```
    4. 等待脚本运行完成，成功后会输出：`脚本执行成功，请按照 Readme 教程继续配置...`。如不成功请参考输出日志解决。

    5. 脚本会自动在`~/jd`下克隆下脚本并创建日志文件夹，分别如下：

        - `log`: 记录所有日志的文件夹，其中跑js脚本的日志会建立对应名称的子文件夹，并且js脚本日志会以`年-月-日-时-分-秒`的格式命名。

        - `scripts`: 从 [lxk0301/jd_scripts](https://github.com/lxk0301/jd_scripts) 克隆的js脚本。

        - `shell`: 从 [EvineDeng/jd-base](https://github.com/EvineDeng/jd-base) 克隆的shell脚本。

## 修改配置

```
cd ~/jd/shell
cp git_pull.sh.sample git_pull.sh  # 复制git_pull.sh.sample为git_pull.sh
nano git_pull.sh
```
参数清单：[Parameter](Parameter.md)，如何修改请见`git_pull.sh`中的注释。

你可以按上面方式直接在nano中修改参数，但可通过其他途径将必要的信息复制过来粘贴（Ctrl + O 保存，Ctrl + X 退出）；

也可以参考上述复制`first_run.sh`文件的复制过程，将`git_pull.sh`复制到外置存储卡，用其他可视化文件编辑器修改好后，再复制回来；

甚至还可以参考上述`Termux`教程，在运行`sshd`服务程序后，通过局域网内的电脑，使用WinSCP软件连接手机进行修改。

## 初始化

**在编辑好`git_pull.sh`这个文件后，请务必手动运行一次`git_pull.sh`，不仅是为检查错误，也是为了运行一次`npm install`用以安装js指定的依赖。**

1. 完成所有信息修改以后，先检查一下git_pull.sh能否正常运行。

    ```
    cd ~/jd/shell
    chmod +x *.sh
    bash git_pull.sh
    ```

    *注1：`.sh`脚本如果没有可执行权限，虽然手动执行可以运行，但定时任务将无法正常运行。*

    *注2：首次运行的日志很重要，如果过程中有任何错误，请参考错误提示来解决问题。主要包括两类问题：一是无法访问github，请想办法改善网络；二是`git_pull.sh`会运行`npm install`，用来安装js指定的依赖，如果你网络不好，日志中会有提示，请注意观察。如果`npm install`失败，请尝试手动运行，可按如下操作，如果失败，可运行多次：*

    ```
    cd ~/jd/scripts
    npm install || npm install --registry=https://registry.npm.taobao.org
    ```

2. 看看js脚本的信息替换是否正常。

    ```
    cd ~/jd/scripts
    git diff    # 请使用上下左右键、Page Down、Page Up进行浏览，按q退出
    ```

3. 然后你可以手动运行一次任何一个以`jd_`开头并以`.sh`结尾的脚本（有些脚本会运行很长时间，sh本身不输入任何内容在屏幕上，而把日志全部记录在日志文件中）。

    ```
    cd ~/jd/shell
    bash jd_bean_sign.sh
    ```

4. 去`~/jd/log/jd_bean_sign`文件夹下查看日志，查看结果是否正常，如不正常，请从头检查。
    ```
    cd ~/jd/log/jd_bean_sign
    ls   # 列出文件
    cat 2020-11-13-12-00-00  # 假如ls列出的文件名是这个的话
    ```

5. 如果不想写入日志文件，想直接在`Termux`中看到输出，那么可以如下操作：
    ```
    cd ~/jd/scripts
    node jd_bean_sign.js
    ```

## 添加定时任务

- 在添加定时任务之前，请先熟悉一下手机上cronie这个软件的用法（你也可以随时输入`crond -h`查看此帮助）：

    ```
    ~/jd/shell/ crond -h
    Usage:
    crond [options]

    Options:
    -h         print this message
    -i         deamon runs without inotify support
    -m <comm>  off, or specify preferred client for sending mails
    -n         run in foreground
    -p         permit any crontab
    -P         use PATH="/data/data/com.termux/files/usr/bin"
    -s         log into syslog instead of sending mails
    -V         print version and exit
    -x <flag>  print debug information

    Debugging flags are: ext,sch,proc,pars,load,misc,test,bit

    ```
    根据帮助文档，如果想要以`deamon`形式启动`cronie`，那么可以输入：
    ```
    crond -i -P
    ```
    **请注意：每次重启手机或重启`Termux`后需要重新输入上述命令。**

    如果输入上述命令后显示类似以下内容的错误，那么表示cronie已经启动好了，无需再次启动：
    ```
    crond: can't lock /data/data/com.termux/files/usr/var/run/crond.pid, otherpid may be 3087: Try again
    ```

- 启动好cronie后，再按以下流程添加定时任务。

    1. 复制一份`crontab.list`到`~/jd`目录下。

        ```
        cd ~/jd
        cp shell/crontab.list.sample crontab.list
        ```

    2. 编辑定时任务并自己根据你的需要调整，

        ```
        nano crontab.list
        ```
        **请注意将`crontab.list`这个文件中的`/root`目录替换为`/data/data/com.termux/files/home/jd`。** 路径主要还是为PC考虑的，手机就请自己修改下吧。以下命令可以批量修改：
        ```
        perl -i -pe "s|/root|/data/data/com.termux/files/home/jd|g" crontab.list
        ```
    3. 添加定时任务。

        ```
        crontab crontab.list
        ```
    4. 做到这里，请再次回过头去查看`申明`部分，请理解在安卓手机下，定时任务不一定准时运行，并且还要注意不要被手机杀掉`Termux`后台进程。

**说明**

- `crontab.list`这个文件必须存放在`~/jd`（和 `shell scripts log` 三个文件夹在同一级）下。

- 第一条定时任务`/data/data/com.termux/files/home/jd/shell/git_pull.sh`会自动更新js脚本和shell脚本，并完成Cookie、互助码等信息修改，这个任务本身的日志会存在`/data/data/com.termux/files/home/jd/log/git_pull.log`中。更新过程不会覆盖掉你已经修改好的`git_pull.sh`文件。

- 第二条定时任务`/data/data/com.termux/files/home/jd/shell/rm_log.sh`用来自动删除旧的js脚本日志，如果你未按下一节`自动删除旧日志`中操作的话，这条定时任务不会生效。

- 当`git_pull.sh`中的`AutoAddCron`设置为`false`时（不自动增加新的定时任务），如何手动添加新增js脚本的定时任务：

    1. 检查有没有新增脚本：
        ```
        cd ~/jd  # 先cd至你存放脚本的目录
        cat log/js-add.list
        ```
    2. 如果上一条命令不为空说明有新的定时任务待添加，把内容记下来，比如有个新增的任务叫为`jd_test`，那么就运行以下命令:
        ```
        cp shell/jd.sh.sample shell/jd_test.sh
        ```
    3. 再次提醒不要忘记赋予可执行权限：
        ```
        chmod +x shell/jd_test.sh
        ```
    4. 编辑crontab.list，并添加进crontab
        ```
        nano crontab.list
        crontab crontab.list
        ```
## 自动删除旧日志

单个日志虽然小，但如果长期运行的话，日志也会占用大量空间，如需要自动删除，请按以下流程操作：

1. 复制一份`rm_log.sh`，并赋予可执行权限：

    ```
    cd ~/jd/shell
    cp rm_log.sh.sample rm_log.sh
    chmod +x rm_log.sh
    ```

2. 该脚本在运行时默认删除`30天`以前的日志，因手机存储空间有限，强烈建议修改脚本中的`HowManyDays`为小一些的天数。另外，也建议修改计划运行时间，针对手机，建议修改为 `50 3 * * *`，即在每天凌晨3：50运行。

3. 按`定时任务`部分的说明修改定时任务（默认一个月只在1日、15日运行一次`rm_log.sh`）。

## 划重点：电量优化策略

这就是手机上运行定时任务的难点了，请各位各显神通，授予`Termux`无限制的后台策略，常见的有：允许常驻后台，允许后台联网，无限制的电量优化等等。至于做了这些操作以后，`Termux`是否仍然偶尔抽风，那我就不得而知了。

但即使这样，遇到特殊情况时，不仍然可以进入`~/jd/scripts/`后手动运行js脚本吗？

如果有个旧的安卓手机，是不是可以考虑一直充电放家中，无限制地运行此脚本？

## 补充说明

- 其实`shell`目录下所有以`jd_`开头以`.sh`结尾的文件内容全都一样，全都是从`jd.sh.sample`复制来的，它们是依靠它们自身的文件名来找到所对应的`scripts`目录下的js文件并且执行的。所以，有新的任务时，只要你把`jd.sh.sample`复制一份和新增的`.js`脚本名称一样，赋予可执行权限，再增加定时任务就可以了。

- 如果想要重新调整定时任务运行时间，请不要直接使用`crontab -e`命令修改，而是编辑`~/jd/crontab.list`这个文件，然后使用`crontab ~/jd/crontab.list`命令覆盖。这样的好处脚本会自动依靠这个文件来增加新的定时任务和删除失效的定时任务。

- 如果shell脚本有更新，需要你手动复制一份`git_pull.sh.sample`，并重新修改必须的信息，然后命名为`git_pull.sh`，流程如下（以docker为例）：
    ```
    cd ~/jd/shell
    cp git_pull.sh.sample git_pull_2.sh

    # 然后修改git_pull_2.sh
    nano git_pull_2.sh

    # 修改好后，替换旧的git_pull.sh
    mv git_pull_2.sh git_pull.sh

    # 不要忘记赋予修改后的.sh脚本可执行权限
    chmod +x git_pull.sh
    ```

- 向经常关注本脚本并且知道何为助力上车的人提供一个自动上车脚本`create_share_codes.sh.sample`，请自行参考上述`git_pull.sh`的修改方法修改为`create_share_codes.sh`，并修改其中必要的信息。在理解[这个链接](http://api.turinglabs.net/api/v1/jd/cleantimeinfo/)的含义之后自行添加定时任务，**有关于此的提问一概不回复，不解释**。

- 如有帮助到你，请点亮 star 。