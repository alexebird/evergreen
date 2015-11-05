on the yun linux
```
opkg update
opkg install curl
opkg install ncat
opkg install bind-dig
opkg install ruby ruby-gems ruby-json ruby-irb
echo 'nameserver 8.8.8.8' > /root/resolv.conf
ln -s /root/resolv.conf /etc/resolv.conf
```
