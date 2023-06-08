#!/bin/sh

# 引用环境变量等

source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
eval `dbus export adguardhome_upx_set`
eval `dbus export adguardhome_update_dir`
eval `dbus export adguardhome_binary_rollback_version`

# 回退adguardhome二进制

check_rollback_adguardhome(){
	local lastver
	echo_date 开始回退 adguardhome 版本。。。
	lastver=$adguardhome_binary_rollback_version
	if [ -e  "$adguardhome_update_dir/adguardhome_update.tar.gz" ] ; then
		rm -rf $adguardhome_update_dir/adguardhome_update.tar.gz
	fi
	echo_date "准备回退到指定版本，开始下载"
	curl  --retry 2  -o $adguardhome_update_dir/adguardhome_update.tar.gz -L  https://github.com/AdguardTeam/AdGuardHome/releases/download/v${lastver}/AdGuardHome_linux_armv5.tar.gz
	#wget --no-check-certificate --timeout=8 --tries=2 -O - "https://github.com/AdguardTeam/AdGuardHome/releases/download/${lastver}/AdGuardHome_linux_armv5.tar.gz" > $adguardhome_update_dir/adguardhome_update.tar.gz
	if [ -e  "$adguardhome_update_dir/adguardhome_update.tar.gz" ] ; then
		echo_date "回退版本已下载，准备安装"
		[ -d "$adguardhome_update_dir/adguardhome_update" ] && rm -rf $adguardhome_update_dir/adguardhome_update
		mkdir -p $adguardhome_update_dir/adguardhome_update
		tar xzf  $adguardhome_update_dir/adguardhome_update.tar.gz -C $adguardhome_update_dir/adguardhome_update
		if [ "$adguardhome_upx_set" == "1" ] ;then
			echo_date "正在使用upx压缩AdGuardHome程序"
			/koolshare/adguardhome/upx $adguardhome_update_dir/adguardhome_update/AdGuardHome/AdGuardHome
			echo_date "已完成压缩AdGuardHome程序"
		fi
		if [  $($adguardhome_update_dir/adguardhome_update/AdGuardHome/AdGuardHome --version | grep "version" |wc -l) == 1 ];then
			/koolshare/adguardhome/adguardhome.sh stop
			echo_date "正在安装AdGuardHome程序"
			cp -rf $adguardhome_update_dir/adguardhome_update/AdGuardHome/AdGuardHome /koolshare/adguardhome/adguardhome
			chmod a+x /koolshare/adguardhome/adguardhome
			echo `/koolshare/adguardhome/adguardhome --version`| sed s/", channel release, arch linux arm v5"//g| sed  s/"AdGuard Home, version "//g | sed  s/"v"//g > /koolshare/adguardhome/binversion
			rm -rf $adguardhome_update_dir/adguardhome_update
			rm -rf $adguardhome_update_dir/adguardhome_update.tar.gz
			echo_date "回退版本已安装，准备重启插件"
			dbus set adguardhome_bin_version=$lastver
			dbus set adguardhome_bin_auto_update=0
			/koolshare/adguardhome/adguardhome.sh restart
		else
			echo_date "压缩AdGuardHome程序错误,无法回退"
		fi
	else
		echo_date "回退版本下载失败，请检查网络到github的连通后再试！"
		sleep 3
		echo XU6J03M6
	fi
}

echo_date "==================================================================="
echo_date "                     adguardhome程序回退                           "
echo_date "==================================================================="
check_rollback_adguardhome
echo_date "==================================================================="
