#!/bin/ash

# bootstrap the arduino linux

set -e
set -vx

cd /root

opkg update
opkg install curl ncat bind-dig ruby ruby-json

if [ ! -f '/root/resolv.conf' ]; then
  echo 'nameserver 8.8.8.8' > /root/resolv.conf
  ln -f -s /root/resolv.conf /etc/resolv.conf
fi

rm -rf evergreen
git clone git://github.com/alexebird/evergreen.git
cd evergreen

# should be in an init script
ruby ./bin/evergreen.rb
