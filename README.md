# Evergreen

Ping-Pong scoreboard.

## Installation

On the yun linux:
```
opkg update
opkg install curl
opkg install ncat
opkg install bind-dig
opkg install ruby ruby-json
echo 'nameserver 8.8.8.8' > /root/resolv.conf
ln -s /root/resolv.conf /etc/resolv.conf

# on start
curl -k https://raw.githubusercontent.com/alexebird/evergreen/master/bin/evergreen.sh | ash
```
