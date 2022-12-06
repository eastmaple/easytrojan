#!/bin/bash
#
# Notes: EasyMyTrojan for CentOS/RedHat 7+ Debian 9+ and Ubuntu 16+
#
# Project home page:
#        https://github.com/maplecool/easytrojan

case $1 in
add)
shift
    for i in "$@" ; do
        if curl -X POST -H "Content-Type: application/json" -d "{\"password\": \"$i\"}" http://127.0.0.1:2019/trojan/users/add ; then
            echo "$i" >> /etc/caddy/trojan/passwd.txt &&
            cat /etc/caddy/trojan/passwd.txt | sort | uniq > /etc/caddy/trojan/passwd.tmp &&
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
list)
    cat /etc/caddy/trojan/passwd.txt
;;
status)
    shift
    for i in "$@" ; do
        hash=$(echo -n "$i" | sha224sum | cut -d ' ' -f1)
        echo "$i data usage: $(cat /etc/caddy/trojan/$hash)"
    done
;;
*)
    echo "Command Examples:"
    echo "./mytrojan add passwd1 passwd2 ..."
    echo "./mytrojan del passwd1 passwd2 ..."
    echo "./mytrojan status passwd1 passwd2 ..."
    echo "./mytrojan list"
;;
esac
