#!/usr/bin/env bash
G="\033[32m"
F="\033[0m"
E="[${R}错误${F}]"
D="/mnt/bak"
echo && echo -e " Onecloud
 ——————————————————
 ${G} 0.${F} Backup
 ${G} 1.${F} Configuration
 ${G} 2.${F} Check
 ——————————————————" && echo
echo
read -e -p " 请输入 [0-2]:" num
case "$num" in
0)
    mkdir ${D} && cp -r /.config ${D} && cp /etc/apt/sources.list ${D} && cp /etc/vsftpd.conf ${D} && cp /etc/rc.local ${D} && cp /etc/network/interfaces ${D} && cp * /etc/netplan ${D}
1)
    echo none > /sys/class/leds/onecloud:blue:alive/trigger && echo none > /sys/class/leds/onecloud:red:alive/trigger && echo none > /sys/class/leds/onecloud:green:alive/trigger && echo 0 > /sys/class/leds/onecloud:blue:alive/brightness && echo 0 > /sys/class/leds/onecloud:red:alive/brightness && echo 0 > /sys/class/leds/onecloud:green:alive/brightness && cp ${D}/sources.list /etc/apt && echo 'deb http://download.opensuse.org/repositories/home:/nikoneko:/test/Debian_11/ /' | sudo tee /etc/apt/sources.list.d/home:nikoneko:test.list && curl -fsSL https://download.opensuse.org/repositories/home:nikoneko:test/Debian_11/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_nikoneko_test.gpg > /dev/null && apt update && apt install qbittorrent-enhanced-nox vsftpd && cp -r ${D}/.config / && cp ${D}/vsftpd.conf /etc && rm /etc/ftpusers && cp ${D}/armbian-default.yaml /etc/netplan && cp ${D}/interfaces /etc/network && netplan apply && netplan generate
2)
    wget -qO- "api.github.com/repos/hzyitc/armbian-onecloud/releases/latest" | grep -o '"tag_name": ".*"' | cut -d'"' -f4
    ;;
*)
    echo
    echo -e " ${E} 请输入数字"
    ;;
esac