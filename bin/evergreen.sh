#!/bin/ash

# bootstrap the arduino linux

set -e
set -vx

mothership='mothership.alxb.us'

cd /root

opkg update && opkg install curl ncat bind-dig ruby ruby-json || exit 1

if [ ! -f '/root/resolv.conf' ]; then
  echo 'nameserver 8.8.8.8' > /root/resolv.conf
  ln -f -s /root/resolv.conf /etc/resolv.conf
fi

ping -c2 $mothership || exit 2

rm -rf evergreen
git clone git://github.com/alexebird/evergreen.git || exit 3

cd evergreen
local ifconfig_f='/root/ifconfig.txt'
ifconfig | tr '\n' '$' > $ifconfig_f
curl -XPOST $mothership:8889/arduino -d @$ifconfig_f || echo couldnt send ifconfig
rm -f $ifconfig_f

kill $(ps | grep ruby | grep -v grep | cut -f2 -d' ')
sleep 2
kill -9 $(ps | grep ruby | grep -v grep | cut -f2 -d' ')

echo starting server...
ruby ./bin/evergreen.rb &
pid=$!
sleep 4
ps | grep $pid | grep -v grep || exit 4

exit 0
