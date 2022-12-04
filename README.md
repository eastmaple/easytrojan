# EasyTrojan #

世界上最简单的Trojan部署脚本，仅需一行命令即可搭建一台代理服务器

该项目会自动提供trojan服务所需的免费域名与证书，无需购买、解析等繁琐操作

支持RHEL 7、8、9 (CentOS、RedHat、AlmaLinux、RockyLinux)、Debian 9、10、11、Ubuntu 16、18、20、22

技术原理不做解释，初衷只为解决个人用户与主机商家频繁被阻断IP的问题，毕竟大量IP被阻断会造成很多后续影响

该项目仅限研究用途，用户应根据所在管辖区的当地法律评估自己的法规遵从义务

---

#### 首次安装 ####
请将结尾的password更换为自己的密码，例如 bash easytrojan.sh 123456，安装成功后会返回trojan的连接参数
```
curl https://raw.githubusercontent.com/maplecool/easytrojan/main/easytrojan.sh -o easytrojan.sh && chmod +x easytrojan.sh && bash easytrojan.sh password
```

#### 放行端口 ####
如果服务器开启了防火墙，应放行TCP443与80端口，如在云厂商的web管理页面有防火墙应同时放行TCP443与80端口
```
# RHEL 7、8、9 (CentOS、RedHat、AlmaLinux、RockyLinux) 放行端口命令
firewall-cmd --permanent --add-port=443/tcp && firewall-cmd --permanent --add-port=80/tcp && firewall-cmd --reload && iptables -F

# Debian 9、10、11、Ubuntu 16、18、20、22 放行端口命令
sudo ufw allow 443/tcp && sudo ufw allow 80/tcp && sudo iptables -F
```
> 验证端口是否放行 (示例IP应修改为trojan服务器的IP)
>
> 通过浏览器访问脚本提供的免费域名，例如1.3.5.7.nip.io </br>
> 如果自动跳转至https，页面显示Service Unavailable，说明端口已放行


#### 重新安装/重置密码 ####
```
systemctl stop caddy.service && rm -rf /caddy/trojan /etc/caddy && curl https://raw.githubusercontent.com/maplecool/easytrojan/main/easytrojan.sh -o easytrojan.sh && chmod +x easytrojan.sh && bash easytrojan.sh password
```

#### 完全卸载 ####
```
systemctl stop caddy.service && systemctl disable caddy.service && rm -rf /caddy /etc/caddy /usr/local/bin/caddy /etc/systemd/system/caddy.service
```

---

#### 脚本说明 ####
- 注意事项

```
必须使用root用户部署

请勿修改端口及配置参数
```

- 免费域名

```
通过nip.io提供的免费域名解析服务获取，域名由ServerIP+nip.io组成
例如你的服务器IP为1.3.5.7，对应的域名则是1.3.5.7.nip.io
```

- 指定域名

仅建议在免费域名被阻断时使用
```
在密码后加入域名即可指定域名重新安装，密码与域名之间应使用空格分隔，执行命令如下：
systemctl stop caddy.service && rm -rf /caddy/trojan /etc/caddy && curl https://raw.githubusercontent.com/maplecool/easytrojan/main/easytrojan.sh -o easytrojan.sh && chmod +x easytrojan.sh && bash easytrojan.sh password yourdomain

*当指定域名后，如需切换回免费域名，必须完全卸载脚本，重新执行首次安装命令
```

- 免费证书

```
通过Caddy的HTTPS模块实现，会自动申请letsencrypt或zerossl的免费证书

curl: (35) error:14094438:SSL routines:ssl3_read_bytes:tlsv1 alert internal error
如果在执行脚本的过程中出现该错误，则说明证书申请失败，应检测服务器的网络环境或稍后重新执行脚本

*关闭防火墙后执行重新安装命令，能大概率解决该错误，如果你不知道如何关闭防火墙，请尝试以下命令：

# RHEL 7、8、9 (CentOS、RedHat、AlmaLinux、RockyLinux)
systemctl stop firewalld.service && systemctl disable firewalld.service

# Debian 9、10、11、Ubuntu 16、18、20、22
sudo ufw disable
```

- 连接参数

IP为1.3.5.7 密码为123456的服务器示例
```
地址：1.3.5.7.nip.io  #根据服务器IP生成（即免费域名）
端口：443
密码：123456          #安装时设置的密码
ALPN: h2/http1.1
```

- 服务伪装

```
非密码正确的trojan客户端访问返回503状态，将trojan伪装成过载的Web服务
```

---

#### 连接方式 ####

客户端的TLS指纹是导致trojan被封端口的重要原因之一，但问题不仅存在于客户端，服务端也应作出对应配置

移动设备建议使用能够开启uTLS指纹功能的客户端，暂未有数据表明其它设备会因未启用uTLS指纹功能被封端口
```
为方便用户理解，配置示例中使用服务器IP:1.3.5.7、密码:123456，实际应修改为trojan服务器真实的连接参数

客户端不只局限于以下几种，仅需支持trojan连接即可
```

- 常见客户端连接trojan示例
>- Windows </br>
> [配置示例](https://raw.githubusercontent.com/maplecool/easytrojan/client/v2rayn-trojan.png) | [V2rayN-Core](https://github.com/2dust/v2rayN/releases) 
>- MacOS </br>
> [配置示例](https://raw.githubusercontent.com/maplecool/easytrojan/client/v2rayu-trojan.png) | [V2rayU](https://github.com/yanue/V2rayU/releases) 
>- Android </br>
> [配置示例](https://raw.githubusercontent.com/maplecool/easytrojan/client/v2rayng-trojan.png) | [V2rayNG](https://github.com/2dust/v2rayNG/releases) 
>- iOS </br>
> [配置示例](https://raw.githubusercontent.com/maplecool/easytrojan/client/shadowrocket-trojan.png) | [Shadowrocket](https://apps.apple.com/us/app/shadowrocket/id932747118) | [AppStore海外代购](https://www.rocketgirls.space/product)

- Xray连接trojan部分示例
```
{
    ...

    "outbounds": [
        {
            "protocol": "trojan",
            "settings": {
                "servers": [
                    {
                        "address": "1.3.5.7",        #连接trojan的服务器IP或域名
                        "port": 443,
                        "password": "123456"         #连接trojan的密码
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp",
                "security": "tls",
                "tlsSettings": {
                    "allowInsecure": false,
                    "serverName": "1.3.5.7.nip.io",  #连接trojan的域名
                    "fingerprint": "chrome",
                    "alpn": "h2,http/1.1"
                }
            }
        }
    ]
}
```

- Clash连接trojan部分示例（仅限非ARM设备）
```
- name: "trojan"
    type: trojan
    server: 1.3.5.7
    port: 443
    password: 123456
    udp: true
    sni: 1.3.5.7.nip.io
    alpn:
      - h2
      - http/1.1
    skip-cert-verify: false
```
> 警告：请勿在移动设备及其它ARM设备上使用Clash及不包含UTLS指纹功能的客户端连接trojan

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

自北京时间2022年10月3日起，不断有中国大陆的用户报告基于TLS的代理服务器被封端口。

>- 普遍现象：先被封禁443端口，更换端口后会在1~2天的时间内被再次封禁，多次更换端口后服务器IP被阻断
>- 讨论结果：客户端指纹、服务端指纹、连接数量过多、TLS in TLS被识别等，总之众说纷纭，没有解决方案，最终归为玄学

该项目经过多台服务器测试，以及与部分包含trojan协议的客户端开发者沟通，总结出了相对可靠的抗封锁方案，由于用户的客户端、网络环境差异很大，不保证部署后一定不封禁端口。

> 样本服务器测试数据：
>- 2022年10月初，2台来自境内用户提供的日常使用的Shadowsocks样本服务器相继被阻断IP
>- 2022年10月初，2台样本服务器更换为trojan协议，客户端使用路由器连接，稳定运行
>- 2022年10月上，多用户使用移动客户端连接其中1台trojan服务器，必定出现1天内被封端口现象
>- 2022年10月上，排查原因，分析变量，调研多个被封样本，推测出三个最有可能的原因
>- 2022年10月中，逐条更换变量测试，最终确定是被封问题来自一个移动端不可描述的原因
>- 2022年10月末，2台服务器在每日约10台设备连接、日流量消耗10~20G的情况下稳定运行
>- 2022年10月末，新购1台封端口重灾区的服务器，并联系了10位使用trojan被封端口的用户，内测该部署方案
>- 2022年11月初，样本服务器中，12台443端口正常，1台被封443端口，原因是客户端跳过了证书验证，更正后稳定运行
>- 2022年11月中，总计13台样本服务器，443端口全部正常，期间有围观用户尝试部署，未收到端口被封反馈
>- 2022年11月末，少量用户在移动设备使用clash客户端连接trojan被封端口，更换为该项目建议的客户端后均稳定运行
>- 2022年11月末，已有超过100台服务器使用该项目部署，暂未收到用户服务器端口被封的反馈
>- 2022年黑色星期五，将该部署方案制作成脚本并发布

[![Stargazers over time](https://starchart.cc/maplecool/easytrojan.svg)](https://starchart.cc/maplecool/easytrojan)

---

#### 鸣谢项目 ####
[CaddyServer](https://github.com/caddyserver/caddy) </br>
[CaddyTrojan](https://github.com/imgk/caddy-trojan)
