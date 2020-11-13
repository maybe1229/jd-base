## 部署环境

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

cd至你想存放脚本的路径之后运行一键安装脚本，假如为`/home/myid/jd`，那么：

**以下全文均以此路径`/home/myid/jd`进行举例，请自行修改为你自己的路径！**

**以下全文均以此路径`/home/myid/jd`进行举例，请自行修改为你自己的路径！**

**以下全文均以此路径`/home/myid/jd`进行举例，请自行修改为你自己的路径！**

```
cd /home/myid/jd

# 使用curl
bash -c "$(curl -fsSL https://raw.githubusercontent.com/EvineDeng/jd-base/main/first_run.sh)"

# 或者使用wget
bash -c "$(wget https://raw.githubusercontent.com/EvineDeng/jd-base/main/first_run.sh -O -)"
```

*注：物理机如需多账号并发，需要创建多个文件夹，然后分别进入每个文件夹后运行上述命令，然后在每个创建的文件夹下都按下面说明配置一下，并且在制定定时任务时，你配置了多少个文件夹，那么同一条定时任务就要重复几次（因为.sh脚本路径不一样）。*

脚本会自动在`/home/myid/jd`下克隆下脚本并创建日志文件夹，分别如下：

- `log`: 记录所有日志的文件夹，其中跑js脚本的日志会建立对应名称的子文件夹，并且js脚本日志会以`年-月-日-时-分-秒`的格式命名。

- `scripts`: 从 [lxk0301/jd_scripts](https://github.com/lxk0301/jd_scripts) 克隆的js脚本。

- `shell`: 从 [EvineDeng/jd-base](https://github.com/EvineDeng/jd-base) 克隆的shell脚本。

## 修改信息

```
cd /home/myid/jd/shell
cp git_pull.sh.sample git_pull.sh  # 复制git_pull.sh.sample为git_pull.sh
nano git_pull.sh                   # 编辑git_pull.sh，如果不习惯，请直接使用可视化编辑器编辑这个文件
```

**注意：**

- *请不要直接修改`git_pull.sh.sample`！而只修改`git_pull.sh`。*

- *Windows用户可以使用WinSCP这个软件，使用STFP协议连接机器在`/home/myid/jd/`下找对应文件,何使用WinSCP请自行百度。*

- *如果在windows下编辑`git_pull.sh`，请使用WinSCP自带编辑器，或 notepad++、VS Code、Sublime Text 3 等软件，请不要使用记事本。*

- [参数清单](Parameter.md)，**如何修改请仔细阅读`git_pull.sh`中的注释。**

## 初始化

**在编辑好`git_pull.sh`这个文件后，请务必手动运行一次`git_pull.sh`，不仅是为检查错误，也是为了运行一次`npm install`用以安装js指定的依赖。**

1. 完成所有信息修改以后，先检查一下git_pull.sh能否正常运行。

    ```
    cd /home/myid/jd/shell
    chmod +x *.sh
    bash git_pull.sh
    ```

    *注1：`.sh`脚本如果没有可执行权限，虽然手动执行可以运行，但定时任务将无法正常运行。*

    *注2：首次运行的日志很重要，如果过程中有任何错误，请参考错误提示来解决问题。主要包括两类问题：一是无法访问github，请想办法改善网络；二是`git_pull.sh`会运行`npm install`，用来安装js指定的依赖，如果你网络不好，日志中会有提示，请注意观察。如果`npm install`失败，请尝试手动运行，可按如下操作，如果失败，可运行多次：*

    ```
    cd /home/myid/jd/scripts
    npm install || npm install --registry=https://registry.npm.taobao.org
    ```

2. 看看js脚本的信息替换是否正常。

    ```
    cd /home/myid/jd/scripts
    git diff    # 请使用上下左右键、Page Down、Page Up进行浏览，按q退出
    ```

3. 然后你可以手动运行一次任何一个以`jd_`开头并以`.sh`结尾的脚本（有些脚本会运行很长时间，sh本身不输入任何内容在屏幕上，而把日志全部记录在日志文件中）。

    ```
    cd /root/shell
    bash jd_bean_sign.sh
    ```

    去`/home/myid/jd/log/jd_bean_sign`文件夹下查看日志，查看结果是否正常，如不正常，请从头检查。

## 定时任务

1. 复制一份`crontab.list`到`/home/myid/jd`目录下。

    ```
    cd /home/myid/jd
    cp shell/crontab.list.sample crontab.list
    ```

2. 编辑定时任务并自己根据你的需要调整，也可以使用其他可视化工具编辑。**请注意将`crontab.list`这个文件中的`/root`目录替换为自己的目录。**

    ```
    nano crontab.list
    ```

3. 添加定时任务。**请注意：以下命令会完整覆盖你当前用户的crontab清单，请务必确认当前用户不存在其他定时任务！！。**

    ```
    crontab crontab.list
    ```

**说明：**

- `crontab.list`这个文件必须存放在`/home/myid/jd`（和 shell scripts log 三个文件夹在同一级）下。

- crond任务日志一般在`/var/log/`下，不在脚本目录，并且一般可能需要开启日志功能才会有。

- 第一条定时任务`.../shell/git_pull.sh`会自动更新js脚本和shell脚本，并完成Cookie、互助码等信息修改，这个任务本身的日志会存在`.../log/git_pull.log`中。更新过程不会覆盖掉你已经修改好的`git_pull.sh`文件。"..."指代你的目录。

- 第二条定时任务`.../shell/rm_log.sh`用来自动删除旧的js脚本日志，如果你未按下一节`自动删除旧日志`中操作的话，这条定时任务不会生效。

- 当`git_pull.sh`中的`AutoAddCron`设置为`false`时（不自动增加新的定时任务），如何手动添加新增js脚本的定时任务：

    1. 检查有没有新增脚本：
        ```
        cd /home/myid/jd  # 先cd至你存放脚本的目录
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

- 如果想使用自动增加定时任务的功能（`git_pull.sh`中`AutoAddCron`设置为`true`），而又不想手动改crontab，那么你的机子必须是北京时间，使用`date`命令可以查看系统时间。

## 自动删除旧日志

单个日志虽然小，但如果长期运行的话，日志也会占用大量空间，如需要自动删除，请按以下流程操作：

1. 复制一份rm_log.sh，并赋予可执行权限：

    ```
    cd /home/myid/jd/shell
    cp rm_log.sh.sample rm_log.sh
    chmod +x rm_log.sh
    ```

2. 该脚本在运行时默认删除`30天`以前的日志，如果需要设置为其他天数，请修改脚本中的`HowManyDays`。

3. 按`定时任务`部分的说明修改定时任务。

## 补充说明

- 其实`shell`目录下所有以`jd_`开头以`.sh`结尾的文件内容全都一样，全都是从`jd.sh.sample`复制来的，它们是依靠它们自身的文件名来找到所对应的`scripts`目录下的js文件并且执行的。所以，有新的任务时，只要你把`jd.sh.sample`复制一份和新增的`.js`脚本名称一样，赋予可执行权限，再增加定时任务就可以了。

- 如果想要重新调整定时任务运行时间，请不要直接使用`crontab -e`命令修改，而是编辑`/home/myid/jd/crontab.list`这个文件，然后使用`crontab /home/myid/jd/crontab.list`命令覆盖。这样的好处脚本会自动依靠这个文件来增加新的定时任务和删除失效的定时任务。

- 如果shell脚本有更新，需要你手动复制一份`git_pull.sh.sample`，并重新修改必须的信息，然后命名为`git_pull.sh`，流程如下（以docker为例）：
    ```
    cd /home/myid/jd/shell
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
