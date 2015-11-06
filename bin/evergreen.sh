#!/bin/ash

# bootstrap the arduino linux

set -e
set -vx

mothership='mothership.alxb.us'

cd /root

exit_code=1

opkg update && opkg install curl ncat bind-dig ruby ruby-json || exit $exit_code
i=$((i+1))

if [ ! -f '/root/resolv.conf' ]; then
  echo 'nameserver 8.8.8.8' > /root/resolv.conf
  ln -f -s /root/resolv.conf /etc/resolv.conf
fi

ping -c2 $mothership || exit $exit_code
i=$((i+1))

rm -rf evergreen
git clone git://github.com/alexebird/evergreen.git || exit $exit_code
i=$((i+1))

cd evergreen
local ifconfig_f='/root/ifconfig.txt'
ifconfig | tr '\n' '$' > $ifconfig_f
curl -XPOST $mothership:8889/arduino -d @$ifconfig_f || echo couldnt send ifconfig
rm -f $ifconfig_f

echo starting server...
# should be in an init script maybe...
ruby ./bin/evergreen.rb
