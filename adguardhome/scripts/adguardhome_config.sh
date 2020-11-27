#!/bin/sh

eval `dbus export adguardhome_enable`

if [ "$adguardhome_enable" == "1" ];then
  /koolshare/adguardhome/adguardhome.sh restart
else
  /koolshare/adguardhome/adguardhome.sh stop
fi
