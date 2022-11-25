# EasyTrojan #

世界上最简单的Trojan部署脚本，仅需一行命令即可搭建一台代理服务器

该项目会自动提供trojan服务所需的免费域名与证书，无需购买、解析等繁琐操作

支持RHEL 7、8、9 (CentOS、RedHat、AlmaLinux、RockyLinux)、Debian 9、10、11、Ubuntu 16、18、20、22

技术原理不做解释，初衷只为解决个人用户与主机商家频繁被阻断IP的问题，毕竟大量IP被阻断会造成很多后续影响

---

#### 首次安装 ####
请将结尾的password更换为自己的密码，例如 bash easytrojan.sh 123456
```
curl https://raw.githubusercontent.com/maplecool/easytrojan/main/easytrojan.sh -o easytrojan.sh && chmod +x easytrojan.sh && bash easytrojan.sh password
```

#### 重新安装/重置密码 ####
```
systemctl stop caddy.service && curl https://raw.githubusercontent.com/maplecool/easytrojan/main/easytrojan.sh -o easytrojan.sh && chmod +x easytrojan.sh && bash easytrojan.sh password
```

#### 完全卸载 ####
```
systemctl stop caddy.service && systemctl disable caddy.service && rm -rf /caddy /etc/caddy /usr/local/bin/caddy
```

---

#### 脚本说明 ####
- 注意事项

```
必须使用root用户部署

必须放行服务器防火墙的TCP443与80端口，部分云服务商如在web管理页面有防火墙也应放开TCP443与80端口

# RHEL 7、8、9 (CentOS、RedHat、AlmaLinux、RockyLinux) 放行端口命令
firewall-cmd --permanent --add-port=443/tcp && firewall-cmd --permanent --add-port=80/tcp && firewall-cmd --reload

# Debian 9、10、11、Ubuntu 16、18、20、22 放行端口命令
sudo ufw allow 443/tcp && sudo ufw allow 80/tcp
```

- 免费域名

```
通过nip.io提供的免费域名解析服务获取，域名由ServerIP+nip.io组成
例如你的服务器IP为1.3.5.7，对应的域名则是1.3.5.7.nip.io
```

- 免费证书

```
通过Carry的HTTPS模块实现，会自动申请letsencrypt或zerossl的免费证书

curl: (35) error:14094438:SSL routines:ssl3_read_bytes:tlsv1 alert internal error
如果在执行脚本的过程中出现该错误，则说明证书申请失败，应检测服务器的网络环境或稍后重新执行脚本
```

- 连接参数

IP为1.3.5.7 密码为123456的服务器示例：
```
地址：1.3.5.7.nip.io  #根据服务器IP生成（即免费域名）
端口：443
密码：123456          #安装时设置的密码
ALPN: h2/http1.1
```

- WEB服务伪装

```
返回503状态进行伪装，如访问域名显示Service Unavailable则说明部署成功
```

---

#### 用户交流 ####
[Telegram Group](https://t.me/easytrojan)

---

#### 赞助项目 ####
- 如果真心想赞助这个项目，帮忙点颗星吧
- 如果解决了封端口的问题，帮忙在各种Issues、论坛、电报群里，看到有相关提问时，转发一下项目链接吧

让更多有需要的用户看到这个项目，就是最好的赞助...

---

#### 数据报告 ####

自北京时间2022年10月3日起，不断有中国大陆的用户报告基于TLS的翻墙服务器被封端口。

>- 普遍现象：先被封禁443端口，更换端口后会在约1~2天的时间内被再次封禁，多次更换端口后服务器IP彻底被阻断
>- 讨论结果：客户端指纹、服务端指纹、连接数量过多、TLS in TLS被识别等，总之众说纷纭，没有解决方案，最终归为玄学

该项目经过多台服务器测试，以及与部分包含trojan协议的客户端开发者沟通，总结出了相对可靠的抗封锁方案，由于用户的客户端、网络环境差异很大，不保证部署后一定不封禁端口。

> 13台样本服务器测试数据：
>- 2022年10月初，2台日常使用的Shadowsocks服务器相继被阻断IP
>- 2022年10月初，2台服务器更换为trojan协议，客户端使用路由器连接，稳定运行
>- 2022年10月上，多用户使用移动客户端连接其中1台trojan服务器，必定出现1天内被封端口现象
>- 2022年10月上，排查原因，分析变量，调研多个被封样本，推测出三个最有可能的原因
>- 2022年10月中，逐条更换变量测试，最终确定是被封问题来自一个移动端不可描述的原因
>- 2022年10月末，2台服务器在每日约10台设备连接、日流量消耗10~20G的情况下，稳定运行
>- 2022年10月末，新购1台封端口重灾区的服务器，并联系了10位使用trojan被封端口的用户，内测新的部署方案
>- 2022年11月初，样本服务器中，12台443端口正常，1台被封443端口，原因是客户端跳过了证书验证，更正后恢复正常
>- 2022年11月中，总计13台样本服务器，443端口全部正常，期间有围观用户进行了部署，暂未收到端口被封的反馈
>- 2022年黑色星期五，将该部署方案制作成脚本并发布

---

#### 鸣谢项目 ####
[caddyserver](https://github.com/caddyserver/caddy) </br>
[caddytrojan](https://github.com/imgk/caddy-trojan)
