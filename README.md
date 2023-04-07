# EasyTrojan #

#### 连接方式 ####

客户端的TLS指纹是导致trojan被封端口的重要原因之一，但问题不仅存在于客户端，服务端也应作出对应配置

移动设备建议使用能够开启uTLS指纹功能的客户端，暂未有数据表明其它设备会因未启用uTLS指纹功能被封端口
```
为方便用户理解，配置示例中使用服务器IP:1.3.5.7、密码:123456，实际应修改为trojan服务器真实的连接参数

客户端不只局限于以下几种，仅需支持trojan连接即可
```

- 常见客户端连接trojan示例
>- Windows </br>
> [配置示例](https://raw.githubusercontent.com/eastmaple/easytrojan/client/v2rayn-trojan.png) | [V2rayN-Core](https://github.com/2dust/v2rayN/releases) 
>- MacOS </br>
> [配置示例](https://raw.githubusercontent.com/eastmaple/easytrojan/client/v2rayu-trojan.png) | [V2rayU](https://github.com/yanue/V2rayU/releases) 
>- Android </br>
> [配置示例](https://raw.githubusercontent.com/eastmaple/easytrojan/client/v2rayng-trojan.png) | [V2rayNG](https://github.com/2dust/v2rayNG/releases) 
>- iOS </br>
> [配置示例](https://raw.githubusercontent.com/eastmaple/easytrojan/client/shadowrocket-trojan.png) | [Shadowrocket](https://apps.apple.com/us/app/shadowrocket/id932747118) | [AppStore海外代购](https://www.rocketgirls.space/product)

- OpenWRT passwall [配置示例](https://raw.githubusercontent.com/eastmaple/easytrojan/client/passwall-trojan.png)

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

- Clash连接trojan部分示例
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
