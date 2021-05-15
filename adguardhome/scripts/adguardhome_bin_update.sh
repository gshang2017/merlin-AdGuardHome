#!/bin/sh

# 引用环境变量等

source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
eval `dbus export adguardhome_bin_version`

# 更新adguardhome二进制

get_latest_release() {
  curl --silent https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}
check_update_adguardhome(){
  local lastver oldver
  echo_date 开始检查 adguardhome 最新版本。。。
  lastver=$(get_latest_release)
    if [ -n "$adguardhome_bin_version" ]; then
      oldver="v$adguardhome_bin_version"
    else
      oldver="v$(echo `/koolshare/adguardhome/adguardhome --version`| sed s/", channel release, arch linux arm v5"//g| sed  s/"AdGuard Home, version "//g | sed  s/"v"//g )"
    fi
  if [ -n "$lastver" ]; then
    echo_date 当前版本：$oldver
    echo_date 最新版本：$lastver
    if [ "$lastver" == "$oldver" ]; then
      echo_date 当前已经是最新版本！
      sleep 3
      echo XU6J03M6
    else
      if [ -e  "/tmp/adguardhome_update.tar.gz" ] ; then
          rm -rf /tmp/adguardhome_update.tar.gz
      fi
      echo_date "准备升级到最新版本，开始下载"
      curl  --retry 2  -o /tmp/adguardhome_update.tar.gz -L  https://github.com/AdguardTeam/AdGuardHome/releases/download/${lastver}/AdGuardHome_linux_armv5.tar.gz
      #wget --no-check-certificate --timeout=8 --tries=2 -O - "https://github.com/AdguardTeam/AdGuardHome/releases/download/${lastver}/AdGuardHome_linux_armv5.tar.gz" > /tmp/adguardhome_update.tar.gz
      if [ -e  "/tmp/adguardhome_update.tar.gz" ] ; then
          echo_date "最新版本已下载，准备安装"
          /koolshare/adguardhome/adguardhome.sh stop
          [ -d "/tmp/adguardhome_update" ] && rm -rf /tmp/adguardhome_update
          mkdir -p /tmp/adguardhome_update
          tar xzf  /tmp/adguardhome_update.tar.gz -C /tmp/adguardhome_update
          cp -rf /tmp/adguardhome_update/AdGuardHome/AdGuardHome /koolshare/adguardhome/adguardhome
          chmod a+x /koolshare/adguardhome/adguardhome
          rm -rf /tmp/adguardhome_update
          rm -rf /tmp/adguardhome_update.tar.gz
          echo_date "最新版本已安装，准备重启插件"
          dbus set adguardhome_bin_version=$lastver
          /koolshare/adguardhome/adguardhome.sh restart
      else
        if [ -e  "/tmp/adguardhome_update.tar.gz" ] ; then
           rm -rf /tmp/adguardhome_update.tar.gz
        fi
        echo_date "最新版本下载失败，请检查网络到github的连通后再试！"
        sleep 3
        echo XU6J03M6
      fi
    fi
  else
    echo_date 最新版本号检查失败，请检查网络到github的连通后再试！
    sleep 3
    echo XU6J03M6
  fi
}



echo_date "==================================================================="
echo_date "                     adguardhome程序更新                           "
echo_date "==================================================================="
check_update_adguardhome
echo_date "==================================================================="
