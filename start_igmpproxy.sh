#!/bin/bash

isroot='sudo ';
whoami=$(whoami);
if [ "$whoami" == "root" ]
then
  isroot='';
fi

while [ "X" == "X" ]
do
  $isroot /usr/local/sbin/igmpproxy -dvv /usr/local/etc/igmpproxy.conf >> /var/log/iptvserver/igmppeoxy.log 2>&1
done

