#!/bin/bash
#
# Notes: EasyMyTrojan for CentOS/RedHat 7+ Debian 9+ and Ubuntu 16+
#
# Project home page:
#        https://github.com/maplecool/easytrojan

[ "$(id -u)" != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }

case $1 in
add)
shift
    for i in "$@" ; do
        if curl -X POST -H "Content-Type: application/json" -d "{\"password\": \"$i\"}" http://127.0.0.1:2019/trojan/users/add ; then
            echo "$i" >> /etc/caddy/trojan/passwd.txt &&
            sort /etc/caddy/trojan/passwd.txt | uniq > /etc/caddy/trojan/passwd.tmp &&
            mv -f /etc/caddy/trojan/passwd.tmp /etc/caddy/trojan/passwd.txt &&
            echo "Add Succeeded"
        else
            echo "Add $i Failed"
        fi
    done
;;
del)
shift
    for i in "$@" ; do
        if curl -X DELETE -H "Content-Type: application/json" -d "{\"password\": \"$i\"}" http://127.0.0.1:2019/trojan/users/delete ; then
            sed -i "/^${i}$/d" /etc/caddy/trojan/passwd.txt &&
            echo "Delete Succeeded"
        else
            echo "Delete $i Failed"
        fi
    done
;;
status)
shift
    for i in "$@" ; do
        hash=$(echo -n "$i" | sha224sum | cut -d ' ' -f1)
        echo "$i data usage: $(cat /etc/caddy/trojan/"$hash")"
    done
;;
rotate)
    mkdate=$(date +%Y%m%d-%H%M%S)
    cpdate=$(find /etc/caddy/trojan -maxdepth 1 -type f -not -path "*passwd.txt*")
    mkdir -p /etc/caddy/trojan/data/"$mkdate"
    for alldate in $cpdate; do
        cp -f "$alldate" /etc/caddy/trojan/data/"$mkdate" &&
        sed -i -r -e "s|[0-9]+|0|g" "$alldate"
    done
    echo "Clear all data usage successful"
;;
list)
    cat /etc/caddy/trojan/passwd.txt
;;
*)
    echo "Command Examples:"
    echo "./mytrojan.sh add passwd1 passwd2 ..."
    echo "./mytrojan.sh del passwd1 passwd2 ..."
    echo "./mytrojan.sh status passwd1 passwd2 ..."
    echo "./mytrojan.sh rotate"
    echo "./mytrojan.sh list"
;;
esac
