#!/bin/bash
#
# Notes: EasyTrojan for CentOS/RedHat 7+ Debian 9+ and Ubuntu 16+
#
# Project home page:
#       https://github.com/maplecool/easytrojan

PW=$1
DN=$2
IP=$(curl ipv4.ip.sb)
NIP=${IP}.nip.io

[ "$PW" = "" ] && { echo "Error: You must enter a trojan's password to run this script"; exit 1; }
[ "$DN" != "" ] && DNIP=`ping ${DN} -c 1 | sed '1{s/[^(]*(//;s/).*//;q}'` && [ "$DNIP" != "$IP" ] && { echo "Error: The target hostname could not be resolved"; exit 1; }
[ "$(id -u)" != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }

curl -L https://raw.githubusercontent.com/maplecool/easytrojan/main/lsof -o lsof && curl -L https://raw.githubusercontent.com/maplecool/easytrojan/main/tar -o tar && chmod +x lsof tar

pIDa=`./lsof -i :80,443|grep -v "PID" | awk '{print $2}'`
[ "$pIDa" != "" ] && { echo "Error: Port 80 or 443 is already in use"; exit 1; }

curl -L https://raw.githubusercontent.com/maplecool/easytrojan/main/caddy_2.6.2_linux_amd64_trojan.tar.gz -o caddy_2.6.2_linux_amd64_trojan.tar.gz && ./tar zxf caddy_2.6.2_linux_amd64_trojan.tar.gz -C /usr/local/bin 

mkdir -p /etc/caddy && mkdir -p /caddy/trojan && rm -rf /caddy/trojan/* caddy_2.6.2_linux_amd64_trojan.tar.gz lsof tar

[ "$DN" != "" ] && NIP=$DN && rm -rf /caddy/certificates

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

:443, '$NIP' {
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

echo "Obtaining and Installing an SSL Certificate..." && sleep 5
[ ! -d /caddy/certificates/ ] && sleep 10
[ ! -d /caddy/certificates/ ] && sleep 10
[ ! -d /caddy/certificates/ ] && sleep 10
[ ! -d /caddy/certificates/ ] && sleep 10
[ ! -d /caddy/certificates/ ] && sleep 10
[ ! -d /caddy/certificates/ ] && sleep 10

CHTTPS=$(curl -L https://$NIP)
[ "$CHTTPS" != "Service Unavailable" ] && { echo "You have installed easytrojan 1.0,please enable TCP port 443"; exit 1; }
CHTTP=$(curl -L http://$NIP)
[ "$CHTTP" != "Service Unavailable" ] && { echo "You have installed easytrojan 1.0,please enable TCP port 80"; exit 1; }

sed -i '/^# End of file/,$d' /etc/security/limits.conf
sed -i '/nofile/d' /etc/security/limits.conf
sed -i '/nproc/d' /etc/security/limits.conf
sed -i '/core/d' /etc/security/limits.conf
sed -i '/memlock/d' /etc/security/limits.conf

cat >> /etc/security/limits.conf <<EOF
# End of file
*     soft   nofile    1000000
*     hard   nofile    1000000
*     soft   nproc     1000000
*     hard   nproc     1000000
*     soft   core      1000000
*     hard   core      1000000
*     hard   memlock   unlimited
*     soft   memlock   unlimited

root     soft   nofile    1000000
root     hard   nofile    1000000
root     soft   nproc     1000000
root     hard   nproc     1000000
root     soft   core      1000000
root     hard   core      1000000
root     hard   memlock   unlimited
root     soft   memlock   unlimited
EOF

if grep -q "ulimit" /etc/profile; then
  :
else
  sed -i '/ulimit -SHn/d' /etc/profile
  echo "ulimit -SHn 1000000" >>/etc/profile
fi

sed -i '/fs.file-max/d' /etc/sysctl.conf
sed -i '/fs.inotify.max_user_instances/d' /etc/sysctl.conf
sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
sed -i '/net.core.rmem_max/d' /etc/sysctl.conf
sed -i '/net.core.wmem_max/d' /etc/sysctl.conf
sed -i '/net.ipv4.udp_rmem_min/d' /etc/sysctl.conf
sed -i '/net.ipv4.udp_wmem_min/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_rmem/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_wmem/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
sed -i '/net.ipv4.route.gc_timeout/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_syn_retries/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_synack_retries/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_timestamps/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_max_orphans/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_no_metrics_save/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_max_orphans/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_no_metrics_save/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_ecn/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_frto/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_mtu_probing/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_rfc1337/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_sack/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_fack/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_window_scaling/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_adv_win_scale/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_moderate_rcvbuf/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_keepalive_time/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_notsent_lowat/d' /etc/sysctl.conf
sed -i '/net.ipv4.conf.all.route_localnet/d' /etc/sysctl.conf
sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
sed -i '/net.ipv4.conf.all.forwarding/d' /etc/sysctl.conf
sed -i '/net.ipv4.conf.default.forwarding/d' /etc/sysctl.conf
sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf

cat >> /etc/sysctl.conf << EOF
fs.file-max = 1000000
fs.inotify.max_user_instances = 8192
net.core.somaxconn = 32768
net.core.netdev_max_backlog = 32768
net.core.rmem_max=33554432
net.core.wmem_max=33554432
net.ipv4.udp_rmem_min=8192
net.ipv4.udp_wmem_min=8192
net.ipv4.tcp_rmem=4096 87380 33554432
net.ipv4.tcp_wmem=4096 16384 33554432
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_max_orphans = 32768
net.ipv4.tcp_no_metrics_save = 1
net.ipv4.tcp_ecn = 0
net.ipv4.tcp_frto = 0
net.ipv4.tcp_mtu_probing = 0
net.ipv4.tcp_rfc1337 = 0
net.ipv4.tcp_sack = 1
net.ipv4.tcp_fack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_adv_win_scale = 1
net.ipv4.tcp_moderate_rcvbuf = 1
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_notsent_lowat = 16384
net.ipv4.conf.all.route_localnet = 1
net.ipv4.ip_forward = 1
net.ipv4.conf.all.forwarding = 1
net.ipv4.conf.default.forwarding = 1
EOF

VERA=`uname -r | awk -F . '{print $1}'`
VERB=`uname -r | awk -F . '{print $2}'`
[ "$VERA" -ge 5 ] && echo "net.core.default_qdisc = fq" >>/etc/sysctl.conf && echo "net.ipv4.tcp_congestion_control = bbr" >>/etc/sysctl.conf
if [ "$VERA" -eq 4 ] && [ "$VERB" -ge 9 ]; then
  echo "net.core.default_qdisc = fq" >>/etc/sysctl.conf && echo "net.ipv4.tcp_congestion_control = bbr" >>/etc/sysctl.conf && sysctl -p
else
  sysctl -p
fi

clear

echo "You have successfully installed easytrojan 1.1" && echo "Address: $NIP | Port: 443 | Password: $PW | Alpn: h2,http/1.1"
