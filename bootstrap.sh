#!/bin/ash

#bootstrap the arduino linux

set -e
set -vx

opkg update && opkg install curl bind-dig coreutils-base64

if [ ! -f '/root/resolv.conf' ]; then
  echo 'nameserver 8.8.8.8' > /root/resolv.conf
  ln -f -s /root/resolv.conf /etc/resolv.conf
fi


#mothership='mothership.alxb.us'

#cd /tmp

#ping -c2 $mothership || exit 2

#rm -rf evergreen
#git clone git://github.com/alexebird/evergreen.git || exit 3

#cd evergreen
#ifconfig_f='/tmp/ifconfig.txt'
#ifconfig | tr '\n' '$' > $ifconfig_f
#curl -XPOST $mothership:8889/arduino -d @$ifconfig_f || echo couldnt send ifconfig
#rm -f $ifconfig_f

#(
  #kill $(ps | grep ruby | grep -v grep | awk '{print $1}')
  #sleep 2
  #kill -9 $(ps | grep ruby | grep -v grep | awk '{print $1}')
#)

#echo starting server...
#ruby ./bin/evergreen.rb /tmp/log/evergreen.log > /dev/null 2>&1 &
#pid=$!
#sleep 4
#ps | grep $pid | grep -v grep || exit 4

#exit 0
