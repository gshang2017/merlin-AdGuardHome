#!/bin/sh

# 版本号定义
version="1.6"

# 引用环境变量等

source /koolshare/scripts/base.sh
export PERP_BASE=/koolshare/perp
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
eval `dbus export adguardhome_enable`
eval `dbus export adguardhome_bin_auto_update`
eval `dbus export adguardhome_dnsmasq_set`
eval `dbus export adguardhome_dns_port`
eval `dbus export adguardhome_perp_set`
eval `dbus export adguardhome_shadowsocks_patch_set`

# ====================================函数定义====================================

# 写入版本号
write_adguardhome_version(){
	dbus set adguardhome_version="$version"
}

# 写入程序版本号
write_adguardhome_bin_version(){
	if [ ! -e /koolshare/adguardhome/binversion ] || [ $(echo `cat /koolshare/adguardhome/binversion`|wc -w) -eq 0 ]; then
		echo `/koolshare/adguardhome/adguardhome --version`| sed s/", channel release, arch linux arm v5"//g| sed  s/"AdGuard Home, version "//g | sed  s/"v"//g > /koolshare/adguardhome/binversion
	fi
	dbus set adguardhome_bin_version=`cat /koolshare/adguardhome/binversion`
}

# DNS设置检查
dns_show_set(){
	if [ -e /koolshare/adguardhome/AdGuardHome.yaml ];then
		dbus set adguardhome_dns_enable=1
	else
		dbus set adguardhome_dns_enable=0
	fi
}

# 启动adguardhome主程序
start_adguardhome(){
	# creat start_up file
	if [ ! -L "/koolshare/init.d/S99adguardhome.sh" ]; then
		if [ `ls /koolshare/init.d|grep "adguardhome.sh"|wc -l` -gt 0 ]; then
			rm /koolshare/init.d/*adguardhome.sh
		fi
		ln -sf /koolshare/adguardhome/adguardhome.sh /koolshare/init.d/S99adguardhome.sh
	fi
	#kill adguardhome 主程序
	kill -9 `pidof adguardhome` >/dev/null 2>&1 &
	#启动守护程序
	perpctl A adguardhome  >/dev/null 2>&1
}

# adguardhome主程序自动更新设定
adguardhome_cru_set(){
	if  [ "$adguardhome_enable" == "1" ] && [ "$adguardhome_bin_auto_update" == "1" ];then
		cru a adguardhomeUpdate "0 5 * * * /koolshare/scripts/adguardhome_bin_update.sh"
	else
		cru d adguardhomeUpdate
	fi
}

# dnsmasq设置
dnsmasq_set(){
	if [ "$adguardhome_enable" == "1" ] && [ -e /koolshare/adguardhome/AdGuardHome.yaml ];then
		if [ "$adguardhome_dnsmasq_set" == "1" ] && [ "$adguardhome_dns_port" != "53" ];then
			# 创建dnsmasq.postconf软连接到/jffs/scripts/文件夹.
			[ ! -L "/jffs/scripts/dnsmasq.postconf" ] && ln -sf /koolshare/adguardhome/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
			if [ -z "`ls -l  /jffs/scripts/dnsmasq.postconf|grep "adguardhome"`" ];then
				rm -rf /jffs/scripts/dnsmasq.postconf
				ln -sf /koolshare/adguardhome/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
			fi
			service restart_dnsmasq >/dev/null 2>&1
		elif [ "$adguardhome_dnsmasq_set" == "2" ] && [ "$adguardhome_dns_port" != "53" ];then
			# 创建dnsmasq.postconf软连接到/jffs/scripts/文件夹.
			[ ! -L "/jffs/scripts/dnsmasq.postconf" ] && ln -sf /koolshare/adguardhome/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
			if [ -z "`ls -l  /jffs/scripts/dnsmasq.postconf|grep "adguardhome"`" ];then
				rm -rf /jffs/scripts/dnsmasq.postconf
				ln -sf /koolshare/adguardhome/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
			fi
			service restart_dnsmasq >/dev/null 2>&1
		elif [ "$adguardhome_dnsmasq_set" == "3" ] && [ "$adguardhome_dns_port" != "53" ];then
			# 删除dnsmasq设置
			if [ -n "`ls -l  /jffs/scripts/dnsmasq.postconf|grep "adguardhome"`" ];then
				rm -rf /jffs/scripts/dnsmasq.postconf
				service restart_dnsmasq >/dev/null 2>&1
			fi
		elif [ "$adguardhome_dnsmasq_set" == "4" ] && [ "$adguardhome_dns_port" != "53" ];then
			# 创建dnsmasq.postconf软连接到/jffs/scripts/文件夹.
			[ ! -L "/jffs/scripts/dnsmasq.postconf" ] && ln -sf /koolshare/adguardhome/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
			if [ -z "`ls -l  /jffs/scripts/dnsmasq.postconf|grep "adguardhome"`" ];then
				rm -rf /jffs/scripts/dnsmasq.postconf
				ln -sf /koolshare/adguardhome/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
			fi
			service restart_dnsmasq >/dev/null 2>&1
		elif [ "$adguardhome_dnsmasq_set" == "5" ] && [ "$adguardhome_dns_port" != "53" ];then
			# 创建dnsmasq.postconf软连接到/jffs/scripts/文件夹.
			[ ! -L "/jffs/scripts/dnsmasq.postconf" ] && ln -sf /koolshare/adguardhome/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
			if [ -z "`ls -l  /jffs/scripts/dnsmasq.postconf|grep "adguardhome"`" ];then
				rm -rf /jffs/scripts/dnsmasq.postconf
				ln -sf /koolshare/adguardhome/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
			fi
			service restart_dnsmasq >/dev/null 2>&1
		else
			# 删除dnsmasq设置
			if [ -n "`ls -l  /jffs/scripts/dnsmasq.postconf|grep "adguardhome"`" ];then
				rm -rf /jffs/scripts/dnsmasq.postconf
				service restart_dnsmasq >/dev/null 2>&1
			fi
		fi
	else
		# 删除dnsmasq设置
		if [ -n "`ls -l  /jffs/scripts/dnsmasq.postconf|grep "adguardhome"`" ];then
			rm -rf /jffs/scripts/dnsmasq.postconf
			service restart_dnsmasq >/dev/null 2>&1
		fi
	fi
}

# nat规则
nat_set(){
	if [ "$adguardhome_enable" == "1" ] && [ -e /koolshare/adguardhome/AdGuardHome.yaml ];then
		if [ "$adguardhome_dnsmasq_set" == "1" ] && [ "$adguardhome_dns_port" != "53" ];then
			# 删除iptables设置
			iptables_nu=`iptables -t nat -L PREROUTING -v -n --line-numbers|grep "dpt:53"|head -n 1|awk '{print $1}'`
			while [ -n "$iptables_nu" ]
			do
				iptables -t nat -D PREROUTING $iptables_nu
				iptables_nu=`iptables -t nat -L PREROUTING -v -n --line-numbers|grep "dpt:53"|head -n 1|awk '{print $1}'`
			done
		elif [ "$adguardhome_dnsmasq_set" == "2" ] && [ "$adguardhome_dns_port" != "53" ];then
			# 删除iptables设置
			iptables_nu=`iptables -t nat -L PREROUTING -v -n --line-numbers|grep "dpt:53"|head -n 1|awk '{print $1}'`
			while [ -n "$iptables_nu" ]
			do
				iptables -t nat -D PREROUTING $iptables_nu
				iptables_nu=`iptables -t nat -L PREROUTING -v -n --line-numbers|grep "dpt:53"|head -n 1|awk '{print $1}'`
			done
		elif [ "$adguardhome_dnsmasq_set" == "3" ] && [ "$adguardhome_dns_port" != "53" ];then
			iptables_nu=`iptables -t nat -L PREROUTING -v -n --line-numbers|grep "dpt:53"|head -n 1|awk '{print $1}'`
			while [ -n "$iptables_nu" ]
			do
				iptables -t nat -D PREROUTING $iptables_nu
				iptables_nu=`iptables -t nat -L PREROUTING -v -n --line-numbers|grep "dpt:53"|head -n 1|awk '{print $1}'`
			done
			iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports $adguardhome_dns_port
			iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports $adguardhome_dns_port
		elif [ "$adguardhome_dnsmasq_set" == "4" ] && [ "$adguardhome_dns_port" != "53" ];then
			# 删除iptables设置
			iptables_nu=`iptables -t nat -L PREROUTING -v -n --line-numbers|grep "dpt:53"|head -n 1|awk '{print $1}'`
			while [ -n "$iptables_nu" ]
			do
				iptables -t nat -D PREROUTING $iptables_nu
				iptables_nu=`iptables -t nat -L PREROUTING -v -n --line-numbers|grep "dpt:53"|head -n 1|awk '{print $1}'`
			done
		elif [ "$adguardhome_dnsmasq_set" == "5" ] && [ "$adguardhome_dns_port" != "53" ];then
			# 删除iptables设置
			iptables_nu=`iptables -t nat -L PREROUTING -v -n --line-numbers|grep "dpt:53"|head -n 1|awk '{print $1}'`
			while [ -n "$iptables_nu" ]
			do
				iptables -t nat -D PREROUTING $iptables_nu
				iptables_nu=`iptables -t nat -L PREROUTING -v -n --line-numbers|grep "dpt:53"|head -n 1|awk '{print $1}'`
			done
		else
			iptables_nu=`iptables -t nat -L PREROUTING -v -n --line-numbers|grep "dpt:53 redir ports"|head -n 1|awk '{print $1}'`
			while [ -n "$iptables_nu" ]
			do
				iptables -t nat -D PREROUTING $iptables_nu
				iptables_nu=`iptables -t nat -L PREROUTING -v -n --line-numbers|grep "dpt:53 redir ports"|head -n 1|awk '{print $1}'`
			done
		fi
	else
		iptables_nu=`iptables -t nat -L PREROUTING -v -n --line-numbers|grep "dpt:53 redir ports"|head -n 1|awk '{print $1}'`
		while [ -n "$iptables_nu" ]
		do
			iptables -t nat -D PREROUTING $iptables_nu
			iptables_nu=`iptables -t nat -L PREROUTING -v -n --line-numbers|grep "dpt:53 redir ports"|head -n 1|awk '{print $1}'`
		done
	fi
}

# 加载nat
load_nat(){
	nat_ready=$(iptables -t nat -L PREROUTING -v -n --line-numbers|grep -v PREROUTING|grep -v destination)
	i=120
	until [ -n "$nat_ready" ]
	do
		i=$(($i-1))
		if [ "$i" -lt 1 ];then
			#错误：不能正确加载nat规则!
			exit
		fi
		sleep 1
		nat_ready=$(iptables -t nat -L PREROUTING -v -n --line-numbers|grep -v PREROUTING|grep -v destination)
	done
	#加载nat规则!
	nat_set
}

#设置perp
perp_set(){
	if [ "$adguardhome_enable" == "1" ] && [ "$adguardhome_perp_set" == "1" ] ;then
		cru d adguardhomeperp
		cru a adguardhomeperp "*/1 * * * *   /koolshare/adguardhome/adguardhome.sh perp_restart"
	elif [ "$adguardhome_enable" == "1" ] && [ "$adguardhome_perp_set" == "2" ] ;then
		cru d adguardhomeperp
		cru a adguardhomeperp "*/10 * * * *   /koolshare/adguardhome/adguardhome.sh perp_restart"
	elif [ "$adguardhome_enable" == "1" ] && [ "$adguardhome_perp_set" == "3" ] ;then
		cru d adguardhomeperp
		cru a adguardhomeperp "*/30 * * * *   /koolshare/adguardhome/adguardhome.sh perp_restart"
	elif [ "$adguardhome_enable" == "1" ] && [ "$adguardhome_perp_set" == "4" ] ;then
		cru d adguardhomeperp
		cru a adguardhomeperp "* */1 * * *   /koolshare/adguardhome/adguardhome.sh perp_restart"
	else
		cru d adguardhomeperp
  fi
}

#设置shadowsocks_patch
shadowsocks_patch_set(){
	if [ "$adguardhome_enable" == "1" ];then
		if [ "$adguardhome_shadowsocks_patch_set" == "1" ];then
			if [ -f /koolshare/ss/rules/dnsmasq.postconf ] && [ ! -f /koolshare/ss/rules/dnsmasq.postconf.adguardhome.bak ] ;then
				cp /koolshare/ss/rules/dnsmasq.postconf  /koolshare/ss/rules/dnsmasq.postconf.adguardhome.bak
			fi
			if [ -f /koolshare/ss/ssconfig.sh ] && [ ! -f /koolshare/ss/ssconfig.sh.adguardhome.bak ] ;then
				cp /koolshare/ss/ssconfig.sh /koolshare/ss/ssconfig.sh.adguardhome.bak
			fi
			if [ `grep "adguardhome-1" /koolshare/ss/rules/dnsmasq.postconf | wc -l` -eq 0 ] ;then
				h1=$(grep -n "all-servers" /koolshare/ss/rules/dnsmasq.postconf | awk -F: '{print $1}')
				sed -i "${h1} a \ \ \ \ \ \ \ \ pc_replace \"cache-size=9999\" \"cache-size=0\" \$CONFIG" /koolshare/ss/rules/dnsmasq.postconf
				sed -i "${h1} a \ \ \ \ \ \ \ \ pc_insert \"no-poll\" \"server=\$CDN\" \"/etc/dnsmasq.conf\"" /koolshare/ss/rules/dnsmasq.postconf
				sed -i "${h1} a \ \ \ \ \ \ \ \ \# 选择自定义DNS端口时候" /koolshare/ss/rules/dnsmasq.postconf
				sed -i "${h1} a \ \ \ \ elif [ \"\$ss_dns_china\" == \"12\" ];then" /koolshare/ss/rules/dnsmasq.postconf
				sed -i "${h1} a \ \ \ \ \# adguardhome-1" /koolshare/ss/rules/dnsmasq.postconf
			fi
			if [ `grep "adguardhome-2" /koolshare/ss/ssconfig.sh | wc -l` -eq 0 ] ;then
				h2=$(grep -n "wan_white_domain\"" /koolshare/ss/ssconfig.sh |grep "CDN#53" | awk -F: '{print $1}')
				sed -i "${h2} a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ fi" /koolshare/ss/ssconfig.sh
				sed -i "${h2} a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ echo \"\$wan_white_domain\" \| sed \"s\/\^\/server=\&\\\/.\/g\" | sed \"s\/\$\/\\\/\$CDN\#53\/g\" >> /tmp/wblist.conf" /koolshare/ss/ssconfig.sh
				sed -i "${h2} a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \# 选择其它国内DNS时候" /koolshare/ss/ssconfig.sh
				sed -i "${h2} a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ else" /koolshare/ss/ssconfig.sh
				sed -i "${h2} a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ echo \"\$wan_white_domain\" \| sed \"s\/\^\/server=\&\\\/.\/g\" \| sed \"s\/\$\/\\\/\$CDN\/g\" >> /tmp/wblist.conf" /koolshare/ss/ssconfig.sh
				sed -i "${h2} a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \# 选择自定义DNS端口时候" /koolshare/ss/ssconfig.sh
				sed -i "${h2} a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ if [ \"\$ss_dns_china\" == \"12\" ];then" /koolshare/ss/ssconfig.sh
				sed -i "${h2} a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \# adguardhome-2" /koolshare/ss/ssconfig.sh
				sed -i "${h2} d" /koolshare/ss/ssconfig.sh
			fi
			if [ `grep "adguardhome-3" /koolshare/ss/ssconfig.sh | wc -l` -eq 0 ] ;then
				h3=$(grep -n "wan_white_domain2\"" /koolshare/ss/ssconfig.sh |grep "CDN#53" | awk -F: '{print $1}')
				sed -i "${h3} a \ \ \ \ \ \ \ \ \ \ \ \ fi" /koolshare/ss/ssconfig.sh
				sed -i "${h3} a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ echo \"\$wan_white_domain2\" \| sed \"s\/\^\/server=\&\\\/.\/g\" | sed \"s\/\$\/\\\/\$CDN\#53\/g\" >> /tmp/wblist.conf" /koolshare/ss/ssconfig.sh
				sed -i "${h3} a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ # 选择其它国内DNS时候" /koolshare/ss/ssconfig.sh
				sed -i "${h3} a \ \ \ \ \ \ \ \ \ \ \ \ else" /koolshare/ss/ssconfig.sh
				sed -i "${h3} a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ echo \"\$wan_white_domain2\" \| sed \"s\/\^\/server=\&\\\/.\/g\" \| sed \"s\/\$\/\\\/\$CDN\/g\" >> /tmp/wblist.conf" /koolshare/ss/ssconfig.sh
				sed -i "${h3} a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \# 选择自定义DNS端口时候" /koolshare/ss/ssconfig.sh
				sed -i "${h3} a \ \ \ \ \ \ \ \ \ \ \ \ if [ \"\$ss_dns_china\" == \"12\" ];then" /koolshare/ss/ssconfig.sh
				sed -i "${h3} a \ \ \ \ \ \ \ \ \ \ \ \ \# adguardhome-3" /koolshare/ss/ssconfig.sh
				sed -i "${h3} d" /koolshare/ss/ssconfig.sh
			fi
			if [ `grep "adguardhome-4" /koolshare/ss/ssconfig.sh | wc -l` -eq 0 ] ;then
				h4=$(grep -n "wan_black_domain\"" /koolshare/ss/ssconfig.sh |grep "CDN#53" | awk -F: '{print $1}')
				sed -i "${h4} a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ fi" /koolshare/ss/ssconfig.sh
				sed -i "${h4} a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ echo \"\$wan_black_domain\" \| sed \"s\/\^\/server=\&\\\/.\/g\" | sed \"s\/\$\/\\\/\$CDN\#53\/g\" >> /tmp/wblist.conf" /koolshare/ss/ssconfig.sh
				sed -i "${h4} a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \# 选择其它国内DNS时候" /koolshare/ss/ssconfig.sh
				sed -i "${h4} a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ else" /koolshare/ss/ssconfig.sh
				sed -i "${h4} a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ echo \"\$wan_black_domain\" \| sed \"s\/\^\/server=\&\\\/.\/g\" \| sed \"s\/\$\/\\\/\$CDN\/g\" >> /tmp/wblist.conf" /koolshare/ss/ssconfig.sh
				sed -i "${h4} a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \# 选择自定义DNS端口时候" /koolshare/ss/ssconfig.sh
				sed -i "${h4} a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ if [ \"\$ss_dns_china\" == \"12\" ];then" /koolshare/ss/ssconfig.sh
				sed -i "${h4} a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \# adguardhome-4" /koolshare/ss/ssconfig.sh
				sed -i "${h4} d" /koolshare/ss/ssconfig.sh
			fi
			ln -sf /koolshare/ss/rules/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
		else
			if [ -f /koolshare/ss/rules/dnsmasq.postconf.adguardhome.bak ] ;then
				mv /koolshare/ss/rules/dnsmasq.postconf.adguardhome.bak  /koolshare/ss/rules/dnsmasq.postconf
				ln -sf /koolshare/ss/rules/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
			fi
			if [ -f /koolshare/ss/ssconfig.sh.adguardhome.bak ] ;then
				mv /koolshare/ss/ssconfig.sh.adguardhome.bak  /koolshare/ss/ssconfig.sh
			fi
		fi
	fi
}

#重启软件中心perp
adguardhome_perp(){
	if ! pidof perpboot > /dev/null; then
		sh /koolshare/perp/perp.sh stop
		sh /koolshare/perp/perp.sh start

	fi
	sleep 5
	if  [ -z "`cru l|grep adguardhomeUpdate`" ] || [ -z "`cru l|grep adguardhomeperp`" ];then
		adguardhome_cru_set
		perp_set
	fi
}

# 停止adguardhome主程序
stop_adguardhome(){
	#停止守护程序
	perpctl X adguardhome  >/dev/null 2>&1
	#kill adguardhome 主程序
	kill -9 `pidof adguardhome` >/dev/null 2>&1 &
	# 删除adguardhome主程序自动更新设定
	cru d adguardhomeUpdate
}

# 自动触发程序
auto_start(){
	# nat_auto_start
	mkdir -p /jffs/scripts
	# creating iptables rules to nat-start
	if [ ! -f /jffs/scripts/nat-start ]; then
	cat > /jffs/scripts/nat-start <<-EOF
		#!/bin/sh
		/usr/bin/onnatstart.sh

		EOF
	chmod +x /jffs/scripts/nat-start
	fi

	writenat=$(cat /jffs/scripts/nat-start | grep "adguardhome")
	if [ -z "$writenat" ];then
		#添加nat-start触发事件...用于adguardhome的nat规则重启后或网络恢复后的加载...
		sed -i '2a sh /koolshare/adguardhome/adguardhome.sh' /jffs/scripts/nat-start
		chmod +x /jffs/scripts/nat-start
	fi

	# wan_auto_start
	# Add service to auto start
	if [ ! -f /jffs/scripts/wan-start ]; then
		cat > /jffs/scripts/wan-start <<-EOF
			#!/bin/sh
			/usr/bin/onwanstart.sh

			EOF
		chmod +x /jffs/scripts/wan-start
	fi

	startadguardhome=$(cat /jffs/scripts/wan-start | grep "/koolshare/scripts/adguardhome_config.sh")
	if [ -z "$startadguardhome" ];then
		#添加wan-start触发事件...
		sed -i '2a sh /koolshare/scripts/adguardhome_config.sh' /jffs/scripts/wan-start
    chmod +x /jffs/scripts/wan-start
	fi
}

case $ACTION in
start)
	#此处为开机自启动设计，只有软件中心adguardhome开启，才会启动adguardhome
	if [ "$adguardhome_enable" == "1" ];then
		write_adguardhome_version
		write_adguardhome_bin_version
		dns_show_set
		start_adguardhome
		adguardhome_cru_set
		auto_start
		dnsmasq_set
		load_nat
		perp_set
		shadowsocks_patch_set
	else
		logger "[软件中心]: adguardhome未设置开机启动，跳过！"
	fi
  ;;
stop | kill )
	stop_adguardhome
	adguardhome_cru_set
	write_adguardhome_version
	write_adguardhome_bin_version
	dnsmasq_set
	load_nat
	perp_set
	shadowsocks_patch_set
  ;;
restart)
	write_adguardhome_version
	write_adguardhome_bin_version
	dns_show_set
	stop_adguardhome
	start_adguardhome
	adguardhome_cru_set
	auto_start
	dnsmasq_set
	load_nat
	perp_set
	shadowsocks_patch_set
  ;;
#设置dns端口网页显示状态、插件版本号、adguardhome程序版本号
show)
	dns_show_set
	echo_date “已设定dns端口网页显示状态”
	write_adguardhome_version
	echo_date “已设定插件版本号”
	write_adguardhome_bin_version
	echo_date “已设定adguardhome程序版本号”
  ;;
perp_restart)
	adguardhome_perp
  ;;
*)
  if [ "$adguardhome_enable" == "1" ];then
		dnsmasq_set
		load_nat
		shadowsocks_patch_set
		adguardhome_cru_set
		perp_set
  fi
  #echo "Usage: $0 (start|stop|restart|kill|show)"
  #exit 1
  ;;
esac
