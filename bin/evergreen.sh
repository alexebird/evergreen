#!/bin/ash

# bootstrap the arduino linux

set -e
set -vx

mothership='mothership.alxb.us'

cd /root

opkg update
opkg install curl ncat bind-dig ruby ruby-json

if [ ! -f '/root/resolv.conf' ]; then
  echo 'nameserver 8.8.8.8' > /root/resolv.conf
  ln -f -s /root/resolv.conf /etc/resolv.conf
fi

ping -c2 $mothership
[ $? -eq 0 ] || exit 1

rm -rf evergreen
git clone git://github.com/alexebird/evergreen.git
[ $? -eq 0 ] || exit 2

cd evergreen
local ifconfig_f='/root/ifconfig.txt'
ifconfig | tr '\n' '$' > $ifconfig_f
curl -XPOST $mothership:8889/arduino -d @$ifconfig_f
#[ $? -eq 0 ] || exit 3
rm -f $ifconfig_f

# should be in an init script maybe...
ruby ./bin/evergreen.rb
