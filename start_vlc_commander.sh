#!/bin/bash

isroot='sudo ';
whoami=$(whoami);
if [ "$whoami" == "root" ]
then
  isroot='';
fi

for pid in $(ps aux | grep vlc_commander.pl | grep -v grep)
do
  kill -9 $pid
done

while [ "X" == "X" ] 
do
  $isroot /usr/iptvserver/vlc_commander.pl /usr/iptvserver/playlist.m3u >> /var/log/iptvserver/vlc_commander.log 2>&1
done
