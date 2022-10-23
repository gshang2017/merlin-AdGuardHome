#!/bin/sh

sh /koolshare/adguardhome/adguardhome.sh stop

rm -rf /koolshare/adguardhome
rm -rf /koolshare/perp/adguardhome
rm -rf /koolshare/scripts/adguardhome_config.sh
rm -rf /koolshare/scripts/adguardhome_bin_update.sh
rm -rf /koolshare/scripts/adguardhome_status.sh
rm -rf /koolshare/scripts/adguardhome_set_status.sh
rm -rf /koolshare/scripts/adguardhome_update.sh
rm -rf /koolshare/webs/Module_adguardhome.asp
rm -rf /koolshare/res/icon-adguardhome.png
rm -rf /koolshare/res/adguardhome_check.htm
rm -rf /koolshare/init.d/S99adguardhome.sh
rm -rf /tmp/adguardhome_workdir

dbus remove adguardhome_enable
dbus remove adguardhome_version
dbus remove adguardhome_bin_version
dbus remove adguardhome_dns_enable
dbus remove adguardhome_port
dbus remove adguardhome_work_dir
dbus remove adguardhome_dns_port
dbus remove adguardhome_bin_auto_update
dbus remove adguardhome_dnsmasq_set
dbus remove adguardhome_perp_set
dbus remove adguardhome_upx_set
dbus remove adguardhome_shadowsocks_patch_set
dbus remove softcenter_module_adguardhome_name

# remove start up command
sed -i '/adguardhome_config.sh/d' /jffs/scripts/wan-start >/dev/null 2>&1
sed -i '/adguardhome.sh/d' /jffs/scripts/nat-start >/dev/null 2>&1

rm -rf /koolshare/scripts/uninstall_adguardhome.sh
