#! /bin/sh

cd /tmp
cp -rf /tmp/adguardhome/adguardhome /koolshare/
cp -rf /tmp/adguardhome/scripts/* /koolshare/scripts/
cp -rf /tmp/adguardhome/webs/* /koolshare/webs/
cp -rf /tmp/adguardhome/res/* /koolshare/res/
cp -rf /tmp/adguardhome/perp/* /koolshare/perp/
cp -rf /tmp/adguardhome/uninstall.sh /koolshare/scripts/uninstall_adguardhome.sh
cd /
rm -rf /tmp/adguardhome/ >/dev/null 2>&1
rm -rf /tmp/adguardhome.tar.gz >/dev/null 2>&1

if [ `ls /koolshare/init.d|grep "adguardhome.sh"|wc -l` -gt 0 ]; then
  rm -rf /koolshare/init.d/*adguardhome.sh
fi

chmod 755 /koolshare/adguardhome/*
chmod 755 /koolshare/init.d/*
chmod 755 /koolshare/scripts/*
chmod 755 /koolshare/perp/adguardhome/*

#设置dns端口网页显示状态、插件版本号、adguardhome程序版本号
/koolshare/adguardhome/adguardhome.sh show
