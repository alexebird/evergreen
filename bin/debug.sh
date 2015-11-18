#!/bin/ash

debug_f='/tmp/evergreen-debug.txt'
debug64_f='/tmp/evergreen-debug64.txt'
ifconfig > $debug_f
/usr/bin/pretty-wifi-info.lua >> $debug_f
cat $debug_f | base64 > $debug64_f
curl -vk -XPUT -H"Authorization: ae79df15-9feb-46ff-9c93-5bcd5b20e065" "$MOTHERSHIP/api/debug" -d @$debug64_f

rm -f /tmp/evergreen-debug*
