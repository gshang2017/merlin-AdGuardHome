#!/bin/sh

# 引用环境变量等

source /koolshare/scripts/base.sh
export PERP_BASE=/koolshare/perp
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
version="1.0"
binversion=$(echo `/koolshare/adguardhome/adguardhome --version`| sed s/", channel release, arch linux arm v5"//g| sed  s/"AdGuard Home, version "//g )
eval `dbus export adguardhome_enable`
eval `dbus export adguardhome_bin_auto_update`
eval `dbus export adguardhome_dnsmasq_set`
eval `dbus export adguardhome_dns_port`

# ====================================函数定义====================================

# 写入版本号
write_adguardhome_version(){
  dbus set adguardhome_version="$version"
}

# 写入程序版本号
write_adguardhome_bin_version(){
  dbus set adguardhome_bin_version="$binversion"
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
  if [ ! -L "/koolshare/init.d/S300adguardhome.sh" ]; then
      ln -sf /koolshare/adguardhome/adguardhome.sh /koolshare/init.d/S300adguardhome.sh
  fi
  #kill adguardhome 主程序
  kill -9 `pidof adguardhome` >/dev/null 2>&1 &
  #启动守护程序
  perpctl A adguardhome  >/dev/null 2>&1
  # adguardhome主程序自动更新设定
  if [ "$adguardhome_bin_auto_update" == "1" ];then
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
		if [ ! -n "`ls -l  /jffs/scripts/dnsmasq.postconf|grep "adguardhome"`" ];then
			rm -rf /jffs/scripts/dnsmasq.postconf
			ln -sf /koolshare/adguardhome/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
		fi
		service restart_dnsmasq >/dev/null 2>&1	 	
    elif [ "$adguardhome_dnsmasq_set" == "2" ] && [ "$adguardhome_dns_port" != "53" ];then
		# 创建dnsmasq.postconf软连接到/jffs/scripts/文件夹.
	    [ ! -L "/jffs/scripts/dnsmasq.postconf" ] && ln -sf /koolshare/adguardhome/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
		if [ ! -n "`ls -l  /jffs/scripts/dnsmasq.postconf|grep "adguardhome"`" ];then
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
		if [ ! -n "`ls -l  /jffs/scripts/dnsmasq.postconf|grep "adguardhome"`" ];then
			rm -rf /jffs/scripts/dnsmasq.postconf
			ln -sf /koolshare/adguardhome/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
		fi
		service restart_dnsmasq >/dev/null 2>&1
    elif [ "$adguardhome_dnsmasq_set" == "5" ] && [ "$adguardhome_dns_port" != "53" ];then
		# 创建dnsmasq.postconf软连接到/jffs/scripts/文件夹.
	    [ ! -L "/jffs/scripts/dnsmasq.postconf" ] && ln -sf /koolshare/adguardhome/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
		if [ ! -n "`ls -l  /jffs/scripts/dnsmasq.postconf|grep "adguardhome"`" ];then
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

	startss=$(cat /jffs/scripts/wan-start | grep "/koolshare/scripts/adguardhome_config.sh")
	if [ -z "$startss" ];then
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
    auto_start
    dnsmasq_set
    load_nat
  else
    logger "[软件中心]: adguardhome未设置开机启动，跳过！"
  fi
  ;;
stop | kill )
  stop_adguardhome
  dnsmasq_set
  load_nat
  ;;
restart)
  write_adguardhome_version
  write_adguardhome_bin_version
  dns_show_set
  stop_adguardhome
  start_adguardhome
  auto_start
  dnsmasq_set
  load_nat
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
*)
  dnsmasq_set
  load_nat
  #echo "Usage: $0 (start|stop|restart|kill|show)"
  #exit 1
  ;;
esac
