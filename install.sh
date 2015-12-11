#!/bin/bash

AR_IP=10.0.40.22
PI_IP=192.169.19.8

scp evergreen-env.sh root@$AR_IP:/root/
scp evergreen.sh root@$AR_IP:/root/

rm -rfv pi.tar.gz
tar -czf pi.tar.gz pi

scp pi.tar.gz root@$AR_IP:/tmp
echo scp /tmp/pi.tar.gz pi@$PI_IP:/home/pi
