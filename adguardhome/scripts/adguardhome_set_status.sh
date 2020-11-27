#! /bin/sh

eval `dbus export adguardhome_port`
eval `dbus export adguardhome_dns_port`

#网页刷新时更新网页设置参数
if [ -e /koolshare/adguardhome/AdGuardHome.yaml ];then
    dns_port_change=0
    web_port_change=0
    dbus set adguardhome_dns_enable=1
    if [ `[ -z $adguardhome_dns_port ] && echo Null || echo NotNull` == "NotNull" ];then
        adg_dns_port=$adguardhome_dns_port
        adg_dns_port_set_1="`grep -wn "port:" /koolshare/adguardhome/AdGuardHome.yaml`"
        adg_dns_port_set="`echo ${adg_dns_port_set_1##*":"}`"
        if [ `[ -z $adg_dns_port_set ] && echo Null || echo NotNull` == "NotNull" ];then
            if [  "$adg_dns_port" != "$adg_dns_port_set" ];then
                 dbus set adguardhome_dns_port=$adg_dns_port_set
                 dns_port_change=1
            fi
        fi
    fi
    if [ `[ -z $adguardhome_port ] && echo Null || echo NotNull` == "NotNull" ];then
        adg_web_port=$adguardhome_port
        adg_web_port_set_1="`grep -wn "bind_port:" /koolshare/adguardhome/AdGuardHome.yaml`"
        adg_web_port_set="`echo ${adg_web_port_set_1##*":"}`"
        if [ `[ -z $adg_web_port_set ] && echo Null || echo NotNull` == "NotNull" ];then
            if [  "$adg_web_port" != "$adg_web_port_set" ];then
                 dbus set adguardhome_port=$adg_web_port_set
                 web_port_change=1
            fi
        fi
    fi
    if [ "$dns_port_change" == "1" ] || [ "$web_port_change" == "1" ] ;then
        /koolshare/adguardhome/adguardhome.sh restart
    fi
else
    dbus set adguardhome_dns_enable=0
fi
