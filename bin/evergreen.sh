#!/bin/ash

# bootstrap the arduino linux

branch='deploy'

cd /root

opkg update
opkg install curl ncat bind-dig ruby ruby-json

if [ ! -f '/root/resolv.conf' ]; then
  echo 'nameserver 8.8.8.8' > /root/resolv.conf
  ln -s /root/resolv.conf /etc/resolv.conf
fi

wget https://github.com/alexebird/evergreen/tarball/$branch
tar xpvf $branch
cd alexebird-evergreen-*

# should be in an init script
./bin/evergreen
