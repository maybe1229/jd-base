# 因为我没有MacOS，所以部分教程我无法写具体，请实施过完整安装过程的人发起PR推过来吧。

## 部署环境

1. 在[Node.js官网](https://nodejs.org/zh-cn/download)下载并安装Node.js长期支持版（已包括npm）；

2. 安装git、wget、curl。

*注：如果上述软件不在这几个路径中：`/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin`，那么请在`/usr/local/bin`目录下创建软连接。*

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

进入`/home/myid/jd`目录，复制`git_pull.sh.sample`为`git_pull.sh`；然后编辑`git_pull.sh`。

**注意：**

- *请不要直接修改`git_pull.sh.sample`！而只修改`git_pull.sh`。*

- [参数清单](Parameter.md)，**如何修改请仔细阅读`git_pull.sh`中的注释。**

## 初始化

**在编辑好`git_pull.sh`这个文件后，请务必手动运行一次`git_pull.sh`，不仅是为检查错误，也是为了运行一次`npm install`用以安装js指定的依赖。**

1. 完成所有信息修改以后，先检查一下git_pull.sh能否正常运行。

    ```
    cd /home/myid/jd/shell
    chmod +x *.sh       
    bash git_pull.sh
    ```

    *注1：# 不确定MacOS下是否需要进行授予可执行权限的操作，请有MacOS的人测试一下。*

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

MacOS下定时任务的操作，请有条件的人来提供。
