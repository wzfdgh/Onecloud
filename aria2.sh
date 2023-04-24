#!/usr/bin/env bash
export PATH=~/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/sbin:/bin
d="/root/.aria2c"
C="${d}/aria2.conf"
l="${d}/aria2.log"
c="/usr/local/bin/aria2c"
G="\033[32m"
R="\033[31m"
F="\033[0m"
I="[${G}信息${F}]"
E="[${R}错误${F}]"
L="https://ghproxy.com/raw.githubusercontent.com/wzfdgh/aria2/main"
v="/proc/version"
V="/etc/issue"
sy() {
    if [[ -f /etc/redhat-release ]]; then
        _r="centos"
    elif cat ${V} | grep -q -E -i "debian"; then
        _r="debian"
    elif cat ${V} | grep -q -E -i "ubuntu"; then
        _r="ubuntu"
    elif cat ${V} | grep -q -E -i "centos|red hat|redhat"; then
        _r="centos"
    elif cat ${v} | grep -q -E -i "debian"; then
        _r="debian"
    elif cat ${v} | grep -q -E -i "ubuntu"; then
        _r="ubuntu"
    elif cat ${v} | grep -q -E -i "centos|red hat|redhat"; then
        _r="centos"
    fi
    a_=$(uname -m)
    [ $(command -v dpkg) ] && _a=$(dpkg --print-architecture | awk -F- '{ print $NF }')
}
s() {
    [[ ! -e ${c} ]] && echo -e "${E} Aria2 未安装" && exit 1
    [[ ! -e ${C} ]] && echo -e "${E} 未找到 Aria2 配置文件" && [[ $1 != "u" ]] && exit 1
}
P_() {
    p=$(ps -ef | grep "aria2c" | grep -v grep | grep -v "start.sh" | grep -v "init.d" | grep -v "service" | awk '{print $2}')
}
dl() {
    if [[ $a_ == i*86 || $_a == i*86 ]]; then
        a_="i386"
    elif [[ $a_ == "x86_64" || $_a == "amd64" ]]; then
        a_="amd64"
    elif [[ $a_ == "aarch64" || $_a == "arm64" ]]; then
        a_="arm64"
    elif [[ $a_ == "armv7l" || $_a == "armhf" ]]; then
        a_="armhf"
    else
        echo -e "${E} 不支持此 CPU 架构" && exit 1
    fi
    wget -t3 -T5 -O- "${L}/${a_}.tar.gz" | tar -xz
    [[ ! -s "aria2c" ]] && echo -e "${E} Aria2 主程序下载失败 " && exit 1
    mv -f aria2c "${c}"
    [[ ! -e ${c} ]] && echo -e "${Error} Aria2 主程序安装失败" && exit 1
    chmod +x ${c}
    echo -e "${I} Aria2 主程序安装成功"
}
Dl() {
wget -t3 -T5 -O- "${L}/aria2.tar.gz" | tar -xz
        [[ -s "aria2.tar.gz" ]] && echo -e "${E} Aria2 配置下载失败" && exit 1
    echo -e "${I} Aria2 配置下载成功"
}
se() {
    if [[ ${_r} = "centos" ]]; then
        wget -t3 -T5 "${L}/centos" -O /etc/init.d/aria2
        [[ ! -s /etc/init.d/aria2 ]] && echo -e "${E} Aria2 服务管理下载失败" && exit 1
        chmod +x /etc/init.d/aria2
        chkconfig --add aria2
        chkconfig aria2 on
    else
        wget -t3 -T5 "${L}/debian" -O /etc/init.d/aria2
        [[ ! -s /etc/init.d/aria2 ]] && echo -e "${E} Aria2 服务管理下载失败" && exit 1
        chmod +x /etc/init.d/aria2
        update-rc.d -f aria2 defaults
    fi
    echo -e "${I} Aria2 服务管理下载成功"
}
i_() {
    if [[ ${_r} = "centos" ]]; then
        yum update
        yum install -y wget curl nano ca-certificates findutils jq tar gzip dpkg
    else
        apt update
        apt install -y wget curl nano ca-certificates findutils jq tar gzip dpkg
    fi
    if [[ ! -s /etc/ssl/certs/ca-certificates.crt ]]; then
        wget -qO- ${L}/ca-certificates.sh | bash
    fi
}
i() {
    [[ -e ${c} ]] && echo -e "${E} Aria2 已安装" && exit 1
    sy
    echo -e "${I} 安装依赖"
    i_
    echo -e "${I} 下载 Aria2 主程序"
    dl
    echo -e "${I} 下载 Aria2 配置"
    Dl
    echo -e "${I} 下载 Aria2 服务管理"
    se
    r_
    r=${P}
    echo -e "${I} 设置防火墙"
    _S
    echo -e "${I} 添加防火墙规则"
    a
    echo -e "${I} 保存防火墙规则"
    _s
    echo -e "${I} 安装完成"
    s_
}
s_() {
    s
    P_
    [[ ! -z ${p} ]] && echo -e "${E} Aria2 正在运行" && exit 1
    /etc/init.d/aria2 start
}
S_() {
    s
    P_
    [[ -z ${p} ]] && echo -e "${E} Aria2 未运行" && exit 1
    /etc/init.d/aria2 stop
}
R_() {
    s
    P_
    [[ ! -z ${p} ]] && /etc/init.d/aria2 stop
    /etc/init.d/aria2 start
}
r_() {
    st=$1
    if [[ ! -e ${C} ]]; then
        if [[ ${st} != "u" ]]; then
            echo -e "${E} 未找到 Aria2 配置文件" && exit 1
        fi
    else
        ct=$(cat ${C} | grep -v '#')
        d=$(echo -e "${ct}" | grep "^dir=" | awk -F "=" '{print $NF}')
        P=$(echo -e "${ct}" | grep "^rpc-listen-port=" | awk -F "=" '{print $NF}')
        k=$(echo -e "${ct}" | grep "^rpc-secret=" | awk -F "=" '{print $NF}')
        b=$(echo -e "${ct}" | grep "^listen-port=" | awk -F "=" '{print $NF}')
        d_=$(echo -e "${ct}" | grep "^dht-listen-port=" | awk -F "=" '{print $NF}')
    fi
}
S() {
    s
    r_
    i4=$(
       curl -s 4.ipw.cn
    )
    i6=$(
       curl -s 6.ipw.cn
    )
    [[ -z "${i4}" ]] && i4="IPv4 地址检测失败"
    [[ -z "${i6}" ]] && i6="IPv6 地址检测失败"
    [[ -z "${d}" ]] && d="未找到配置参数"
    [[ -z "${P}" ]] && P="未找到配置参数"
    [[ -z "${k}" ]] && k="未找到配置参数/无密钥"
    if [[ -z "${i4}" || -z "${P}" ]]; then
        A_="null"
    else
        A="/#!/settings/rpc/set/ws/[${i6}]/${P}/jsonrpc/$(echo -n ${k} | base64)"
        A_="http://ariang.mayswind.net/latest${A}"
    fi
    clear
    echo -e "\nAria2 配置信息概要：\n
 IPv4 地址\t: ${G}${i4}${F}
 IPv6 地址\t: ${G}${i6}${F}
 RPC 端口\t: ${G}${P}${F}
 RPC 密钥\t: ${G}${k}${F}
 下载目录\t: ${G}${d}${F}
 AriaNg 链接\t: ${G}${A_}${F}\n"
}
L_() {
    [[ ! -e ${l} ]] && echo -e "${E} 未找到 Aria2 日志文件" && exit 1
    echo && echo -e "${R}按Ctrl+C${F} 退出" && echo -e "查看完整日志，请使用 ${R}cat ${l}${F}" && echo
    tail -f ${l}
}
T() {
    s
    P_
    [[ -z $p ]] && {
        bash <(wget -qO- ${L}/tracker.sh) ${C}
    } || {
        bash <(wget -qO- ${L}/tracker.sh) ${C} RPC
    }
}
U() {
    s "u"
    echo "卸载 Aria2 ?"
    read -e -p "(Y/n):" unyn
    [[ -z ${unyn} ]] && unyn="y"
    if [[ ${unyn} == [Yy] ]]; then
        P_
        [[ ! -z $p ]] && kill -9 ${p}
        r_ "u"
        D
        _s
        rm -rf "${c}"
        if [[ ${_r} = "centos" ]]; then
            chkconfig --D aria2
        else
            update-rc.d -f aria2 remove
        fi
        rm -rf "/etc/init.d/aria2"
        echo "Aria2 卸载成功"
    else
        echo "取消"
    fi
}
a() {
    iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport ${r} -j ACCEPT
    iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport ${b} -j ACCEPT
    iptables -I INPUT -m state --state NEW -m udp -p udp --dport ${d_} -j ACCEPT
}
D() {
    iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport ${P} -j ACCEPT
    iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport ${b} -j ACCEPT
    iptables -D INPUT -m state --state NEW -m udp -p udp --dport ${d_} -j ACCEPT
}
_s() {
    if [[ ${_r} == "centos" ]]; then
        service iptables save
    else
        iptables-save >/etc/iptables.up.rules
    fi
}
_S() {
    if [[ ${_r} == "centos" ]]; then
        service iptables save
        chkconfig --level 2345 iptables on
    else
        iptables-save >/etc/iptables.up.rules
        echo -e '#!/bin/bash\n/sbin/iptables-restore < /etc/iptables.up.rules' >/etc/network/if-pre-up.d/iptables
        chmod +x /etc/network/if-pre-up.d/iptables
    fi
}
echo && echo -e " Onecloud - Aria2
 ——————————————————
 ${G} 1.${F} 安装
 ${G} 2.${F} 卸载
 ${G} 3.${F} 启动
 ${G} 4.${F} 停止
 ${G} 5.${F} 重启
 ${G} 6.${F} 查看配置
 ${G} 7.${F} 查看日志
 ${G} 8.${F} 更新Tracker
 ——————————————————" && echo
if [[ -e ${c} ]]; then
    P_
    if [[ ! -z "${p}" ]]; then
        echo -e " Aria2 状态: ${G}已安装${F} | ${G}已启动${F}"
    else
        echo -e " Aria2 状态: ${G}已安装${F} | ${R}未启动${F}"
    fi
else
    echo -e " Aria2 状态: ${R}未安装${F}"
fi
echo
read -e -p " 请输入 [1-8]:" num
case "$num" in
1)
    i
    ;;
2)
    U
    ;;
3)
    s_
    ;;
4)
    S_
    ;;
5)
    R_
    ;;
6)
    S
    ;;
7)
    L_
    ;;
8)
    T
    ;;
*)
    echo
    echo -e " ${E} 请输入数字"
    ;;
esac