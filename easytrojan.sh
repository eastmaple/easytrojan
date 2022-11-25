#!/bin/bash
#
# Notes: EasyTrojan for CentOS/RedHat 7+ Debian 9+ and Ubuntu 16+
#
# Project home page:
#       https://github.com/maplecool/easytrojan
PW=$1
IP=$(curl ipv4.ip.sb)

[ "$PW" = "" ] && { echo "Error: You must enter a trojan's password to run this script"; exit 1; }
[ "$(id -u)" != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }

curl -L https://raw.githubusercontent.com/maplecool/easytrojan/main/lsof -o lsof && curl -L https://raw.githubusercontent.com/maplecool/easytrojan/main/tar -o tar && chmod +x lsof tar

pIDa=`./lsof -i :80,443|grep -v "PID" | awk '{print $2}'`
[ "$pIDa" != "" ] && { echo "Error: Port 80 or 443 is already in use"; exit 1; }

curl -L https://raw.githubusercontent.com/maplecool/easytrojan/main/caddy_2.6.2_linux_amd64_trojan.tar.gz -o caddy_2.6.2_linux_amd64_trojan.tar.gz && ./tar zxf caddy_2.6.2_linux_amd64_trojan.tar.gz -C /usr/local/bin 

rm -rf lsof tar

mkdir -p /etc/caddy && mkdir -p /caddy/trojan && rm -rf /caddy/trojan/*

echo '{
    order trojan before file_server
    servers :443 {
        listener_wrappers {
            trojan
        }
        protocols h2 h1
    }
    trojan {
        caddy
        no_proxy
    }
}

:443, '$IP'.nip.io {
    tls '$IP'@nip.io {
        protocols tls1.2 tls1.2
        ciphers TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256 TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256
    }
    log {
        level ERROR
    }
    respond "Service Unavailable" 503 {
        close
    }
}

:80 {
    redir https://{host}{uri} permanent
}
'>/etc/caddy/Caddyfile

echo '[Unit]
Description=Caddy
Documentation=https://caddyserver.com/docs/
After=network.target network-online.target
Requires=network-online.target

[Service]
Type=notify
ExecStart=/usr/local/bin/caddy run --environ --config /etc/caddy/Caddyfile
ExecReload=/usr/local/bin/caddy reload --config /etc/caddy/Caddyfile --force
TimeoutStopSec=5s
LimitNOFILE=1048576
LimitNPROC=512
PrivateTmp=true
ProtectSystem=full
AmbientCapabilities=CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target
'>/etc/systemd/system/caddy.service

systemctl daemon-reload && systemctl restart caddy.service && systemctl enable caddy.service

curl -X POST -H "Content-Type: application/json" -d '{"password": "'$PW'"}' http://127.0.0.1:2019/trojan/users/add

echo "Obtaining and Installing an SSL Certificate..." && sleep 10
[ ! -d /caddy/certificates/ ] && sleep 60

CHTTPS=$(curl -L https://$IP.nip.io)
[ "$CHTTPS" != "Service Unavailable" ] && { echo "You have installed easytrojan 1.0,please enable TCP port 443"; exit 1; }
CHTTP=$(curl -L http://$IP.nip.io)
[ "$CHTTP" != "Service Unavailable" ] && { echo "You have installed easytrojan 1.0,please enable TCP port 80"; exit 1; }

echo "You have successfully installed easytrojan 1.0"
echo "Address: $IP.nip.io | Password: $PW"
