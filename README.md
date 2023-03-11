![language](https://img.shields.io/badge/language-Shell_&_Go-brightgreen.svg)
![release](https://img.shields.io/badge/release-v2.0_20221212-blue.svg)
# EasyTrojan #

该分支用于提供二进制文件下载，以解决caddy官网在线编译不稳定的问题

有顾虑的用户可使用xcaddy自行编译后替换/usr/local/bin目录中的caddy二进制文件

---

#### Linux (amd64) 编译示例 ####

- 配置Go环境
```
curl -L https://go.dev/dl/go1.19.7.linux-amd64.tar.gz | tar -zx -C /usr/local
echo 'export PATH=$PATH:/usr/local/go/bin' > /etc/profile.d/golang.sh
source /etc/profile.d/golang.sh
go version
```

- 使用xcaddy编译包含trojan插件的caddy
```
curl -L https://github.com/caddyserver/xcaddy/releases/download/v0.3.2/xcaddy_0.3.2_linux_amd64.tar.gz | tar -zx -C /usr/local/bin xcaddy
cd /usr/local/bin
GOOS=linux GOARCH=amd64 xcaddy build --with github.com/imgk/caddy-trojan
caddy version
```
---

#### Linux (arm64) 编译示例 ####

- 配置Go环境
```
curl -L https://go.dev/dl/go1.19.7.linux-arm64.tar.gz | tar -zx -C /usr/local
echo 'export PATH=$PATH:/usr/local/go/bin' > /etc/profile.d/golang.sh
source /etc/profile.d/golang.sh
go version
```

- 使用xcaddy编译包含trojan插件的caddy
```
curl -L https://github.com/caddyserver/xcaddy/releases/download/v0.3.2/xcaddy_0.3.2_linux_arm64.tar.gz | tar -zx -C /usr/local/bin xcaddy
cd /usr/local/bin
GOOS=linux GOARCH=arm64 xcaddy build --with github.com/imgk/caddy-trojan
caddy version
```
---

#### 鸣谢项目 ####
[CaddyServer](https://github.com/caddyserver/caddy) </br>
[CaddyTrojan](https://github.com/imgk/caddy-trojan)
