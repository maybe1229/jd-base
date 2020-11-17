## 部署环境

1. 在[Node.js官网](https://nodejs.org/zh-cn/download)下载并安装Node.js长期支持版（已包括npm）；

2. 安装git、wget、curl、perl，可能某个软件已经集成在系统中。

    *注：如果上述软件不在这几个路径中：`/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin`，那么请在`/usr/local/bin`目录下创建软连接。*

## 克隆脚本

请不要完全照抄下面的命令，请替换为自己的用户名。

cd至你想存放脚本的路径之后运行一键安装脚本，假如为`/Users/用户名/jd`，那么：

**以下全文均以此路径`/Users/用户名/jd`进行举例，请自行修改为你自己的路径！**

**以下全文均以此路径`/Users/用户名/jd`进行举例，请自行修改为你自己的路径！**

**以下全文均以此路径`/Users/用户名/jd`进行举例，请自行修改为你自己的路径！**

```
cd /Users/用户名/jd

# 使用curl
bash -c "$(curl -fsSL https://raw.githubusercontent.com/EvineDeng/jd-base/main/first_run.sh)"

# 或者使用wget
bash -c "$(wget https://raw.githubusercontent.com/EvineDeng/jd-base/main/first_run.sh -O -)"
```

*注：物理机如需多账号并发，需要创建多个文件夹，然后分别进入每个文件夹后运行上述命令，然后在每个创建的文件夹下都按下面说明配置一下，并且在制定定时任务时，你配置了多少个文件夹，那么同一条定时任务就要重复几次（因为.sh脚本路径不一样）。*

脚本会自动在`/Users/用户名/jd`下克隆下脚本并创建日志文件夹，分别如下：

- `log`: 记录所有日志的文件夹，其中跑js脚本的日志会建立对应名称的子文件夹，并且js脚本日志会以`年-月-日-时-分-秒`的格式命名。

- `scripts`: 从 [lxk0301/jd_scripts](https://github.com/lxk0301/jd_scripts) 克隆的js脚本。

- `shell`: 从 [EvineDeng/jd-base](https://github.com/EvineDeng/jd-base) 克隆的shell脚本。

## 修改信息

进入`/Users/用户名/jd`目录，复制`git_pull.sh.sample`为`git_pull.sh`；然后编辑`git_pull.sh`。

**注意：**

- *请不要直接修改`git_pull.sh.sample`！而只修改`git_pull.sh`。*

- [参数清单](Parameter.md)，**如何修改请仔细阅读`git_pull.sh`中的注释。**

## 初始化

**在首次编辑好`git_pull.sh`这个文件后，请务必手动运行一次`git_pull.sh`，不仅是为检查错误，也是为了运行一次`npm install`用以安装js指定的依赖。**

**在其他任何时候，只要你编辑过`git_pull.sh`，又想马上看到效果，请必须手动运行一次`git_pull.sh`！**

1. 完成所有信息修改以后，先检查一下git_pull.sh能否正常运行。

    ```
    cd /Users/用户名/jd/shell
    chmod +x *.sh       
    bash git_pull.sh
    ```

    *注：首次运行的日志很重要，如果过程中有任何错误，请参考错误提示来解决问题。主要包括两类问题：一是无法访问github，请想办法改善网络；二是`git_pull.sh`会运行`npm install`，用来安装js指定的依赖，如果你网络不好，日志中会有提示，请注意观察。如果`npm install`失败，请尝试手动运行，可按如下操作，如果失败，可运行多次：*

    ```
    cd /Users/用户名/jd/scripts
    npm install || npm install --registry=https://registry.npm.taobao.org
    ```

    出现类似以下字样才表示运行成功：
    ```
    audited 205 packages in 3.784s

    11 packages are looking for funding
    run `npm fund` for details

    found 0 vulnerabilities
    ```

2. 看看js脚本的信息替换是否正常。

    ```
    cd /Users/用户名/jd/scripts
    git diff    # 请使用上下左右键、Page Down、Page Up进行浏览，按q退出
    ```

3. 然后你可以手动运行一次任何一个以`jd_`开头并以`.sh`结尾的脚本（有些脚本会运行很长时间，sh本身不输入任何内容在屏幕上，而把日志全部记录在日志文件中）。

    ```
    cd /Users/用户名/myjd/jd/shell
    bash jd_bean_sign.sh
    ```

    去`/Users/用户名/jd/log/jd_bean_sign`文件夹下查看日志，查看结果是否正常，如不正常，请从头检查。

4. 如何想在终端中看到输出，那么可如下操作：

    ```
    cd /Users/用户名/jd/scripts
    node jd_bean_sign.js
    ```

## 定时任务

1. 进入`/Users/用户名/jd/shell`目录，复制`crontab.list.sample`为`crontab.list`到`/Users/用户名/jd`目录下，然后编辑`crontab.list`。

2. 编辑定时任务并自己根据你的需要调整，也可以使用其他可视化工具编辑。**请注意将`crontab.list`这个文件中的`/root`目录替换为自己的目录。**

    ```
    nano crontab.list
    ```

3. 添加定时任务。**请注意：以下命令会完整覆盖你当前用户的crontab清单，请务必确认当前用户不存在其他定时任务！！。**

    ```
    crontab crontab.list
    ```
**说明：**

- `crontab.list`这个文件必须存放在`/Users/用户名/jd`（和 shell scripts log 三个文件夹在同一级）下。

- 第一条定时任务`/Users/用户名/jd/shell/git_pull.sh`会自动更新js脚本和shell脚本，并完成Cookie、互助码等信息修改，这个任务本身的日志会存在`/Users/用户名/jd/log/git_pull.log`中。更新过程不会覆盖掉你已经修改好的`git_pull.sh`文件。

- 第二条定时任务`/Users/用户名/jd/shell/rm_log.sh`用来自动删除旧的js脚本日志，如果你未按下一节`自动删除旧日志`中操作的话，这条定时任务不会生效。

- 当`git_pull.sh`中的`AutoAddCron`设置为`false`时（不自动增加新的定时任务），如何手动添加新增js脚本的定时任务：

    1. 检查有没有新增脚本：
        ```
        cd /Users/用户名/jd  # 先cd至你存放脚本的目录
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
    cd /Users/用户名/jd/shell
    cp rm_log.sh.sample rm_log.sh
    chmod +x rm_log.sh
    ```

2. 该脚本在运行时默认删除`30天`以前的日志，如果需要设置为其他天数，请修改脚本中的`HowManyDays`。

3. 按`定时任务`部分的说明修改定时任务。

## 补充说明

- 其实`shell`目录下所有以`jd_`开头以`.sh`结尾的文件内容全都一样，全都是从`jd.sh.sample`复制来的，它们是依靠它们自身的文件名来找到所对应的`scripts`目录下的js文件并且执行的。所以，有新的任务时，只要你把`jd.sh.sample`复制一份和新增的`.js`脚本名称一样，赋予可执行权限，再增加定时任务就可以了。

- 如果想要重新调整定时任务运行时间，请不要直接使用`crontab -e`命令修改，而是编辑`/Users/用户名/jd/crontab.list`这个文件，然后使用`crontab /Users/用户名/jd/crontab.list`命令覆盖。这样的好处脚本会自动依靠这个文件来增加新的定时任务和删除失效的定时任务。

- 如果shell脚本有更新，需要你手动复制一份`git_pull.sh.sample`，并重新修改必须的信息，然后命名为`git_pull.sh`，流程如下：
    ```
    cd /Users/用户名/jd/shell
    cp git_pull.sh.sample git_pull_2.sh

    # 然后修改git_pull_2.sh，你也可以可视化编辑
    nano git_pull_2.sh
    
    # 修改好后，替换旧的git_pull.sh
    mv git_pull_2.sh git_pull.sh

    # 不要忘记赋予修改后的.sh脚本可执行权限
    chmod +x git_pull.sh
    ```

- 如有帮助到你，请点亮 star 。
