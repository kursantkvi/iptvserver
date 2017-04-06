#!/bin/bash
isroot='';
isrootend="";
whoami=$(whoami);
if [ "$whoami" == "root" ]
then
  isroot="su totoro -c ";
  isrootend="'";
fi

for pid in $(ps aux  |grep plugins-cache | grep vlc | awk '{ print $2 }') 
do
  kill -9 $pid
done


while [ 'X' == 'X' ] 
do
  $isroot '/usr/bin/vlc --miface eth1 --http-reconnect  --file-caching 10000 --live-caching 10000 --disc-caching 10000 --network-caching 10000 --plugins-cache --reset-plugins-cache --dash-buffersize 3 --ttl 12 --color -I telnet --telnet-password 123 --http-user-agent "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36">> /var/log/iptvserver/vlc_stream.log 2>&1'
done
