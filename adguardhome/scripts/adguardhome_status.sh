#! /bin/sh

status=`pidof adguardhome | wc -w`

if [ "$status" == "0" ];then
  echo 【警告】：adguardhome进程未运行！ > /tmp/adguardhome.log
else
  echo adguardhome进程运行正常！共计"$status"个进程！ > /tmp/adguardhome.log
fi
echo XU6J03M6 >> /tmp/adguardhome.log
sleep 2
rm -rf /tmp/adguardhome.log
