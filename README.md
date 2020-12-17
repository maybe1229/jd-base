## 所有教程已转移至[WIKI](https://github.com/EvineDeng/jd-base/wiki)，如有帮助到你，请点亮Star

## 如有二次使用，希望注明来源

本脚本是[https://github.com/lxk0301/jd_scripts](https://github.com/lxk0301/jd_scripts)的shell套壳工具，适用于以下系统：

- ArmBian/Debian/Ubuntu/OpenMediaVault/CentOS/Fedora/RHEL等Linux系统

- OpenWRT

- Android

- MacOS

- Docker

## 说明

1. 宠汪汪赛跑助力先让用户提供的各个账号之间相互助力，助力完成你提供的所有账号以后，再给我和lxk0301大佬助力，每个账号助力后可得30g狗粮。

2. 将部分临时活动修改为了我的邀请码，已取得lxk0301大佬的同意。

## 更新日志

> 只记录大的更新，小修小改不记录。

- 2020-12-13：rm_log.sh增加删除指定时间以前的git_pull.sh和crond运行日志的功能。

- 2020-12-14：增加定义宠汪汪参加比赛类型的功能，如果需要使用此功能，请重新将`v2.3.11`版本的git_pull.sh.sample配置为git_pull.sh，或者直接在你原来的git_pull.sh中增加`teamLevel`参数。

- 2020-12-16：1. 增加jd_jdzz（京东赚赚）和jd_joy_run（宠汪汪赛跑）的长期定时任务，当`AutoAddCron=true`时，短期任务会自动添加的。2. 将用户提供的所有Cookie中的PIN附加在`jd_joy_run.js`文件中，这样你的各个账号之间将相互助力宠汪汪赛跑，在助力完成你的账号以后，再给我和lxk0301大佬的账号助力，每个Cookie助力可得30g狗粮。

- 2020-12-17：增加jd_watch（京东发现-看一看）的初始任务，该脚本内置了80个body，不过建议有能力者自行抓包，以防止有可能的黑号，抓包教程及使用方法详见该脚本内的注释说明，引用如下：

> 使用 Charles 抓包，使用正则表达式：functionId=disc(AcceptTask|DoTask) 过滤请求
> 选中所有请求，将所有请求保存为 JSON Session File 名称为 watch.chlsj，将该文件与jd_watch.js放在相同目录中

## Star趋势

[![Stargazers over time](https://starchart.cc/EvineDeng/jd-base.svg)](https://starchart.cc/EvineDeng/jd-base)
