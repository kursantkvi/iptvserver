#!/bin/bash

isroot='sudo ';
whoami=$(whoami);
if [ "$whoami" == "root" ]
then
  isroot='';
fi

for pid in $(ps aux | grep netserfet.pl | grep -v grep) 
do
  kill -9 $pid
done

while [ "X" == "X" ]
do
  $isroot /usr/iptvserver/netserfet.pl >> /var/log/iptvserver/netserfer.log 2>&1
done

