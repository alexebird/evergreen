#!/bin/ash

debug_f='/tmp/evergreen-debug.txt'
debug64_f='/tmp/evergreen-debug64.txt'
ifconfig > $debug_f
/usr/bin/pretty-wifi-info.lua >> $debug_f
cat $debug_f | base64 > $debug64_f
curl -v -XPUT "$MOTHERSHIP/api/debug" -d @$debug64_f
rm -f /tmp/evergreen-debug*
