#!/bin/ash

# bootstrap the arduino linux

set -e
set -vx

branch='deploy'
archive="${branch}.tar.gz"

cd /root

opkg update
opkg install curl ncat bind-dig ruby ruby-json

if [ ! -f '/root/resolv.conf' ]; then
  echo 'nameserver 8.8.8.8' > /root/resolv.conf
  ln -f -s /root/resolv.conf /etc/resolv.conf
fi

rm -rf alexebird-evergreen-*
curl -L -k https://github.com/alexebird/evergreen/archive/${branch}.tar.gz -o ${archive}
tar xzf $archive
rm -f $archive
cd alexebird-evergreen-*

# should be in an init script
ruby ./bin/evergreen.rb
