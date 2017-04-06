#!/bin/bash

#netsnifer
srt=$(ps aux | grep start_netserfet.sh | grep -v grep)
if [ "X" == "X$srt" ] 
then
  /usr/iptvserver/start_netserfet.sh &
fi

#vlc
srt=$(ps aux | grep start_vlc.sh | grep -v grep)
if [ "X" == "X$srt" ]
then
  /usr/iptvserver/start_vlc.sh &
fi

#vlc_commander
srt=$(ps aux | grep start_vlc_commander.sh | grep -v grep)
if [ "X" == "X$srt" ]
then
  /usr/iptvserver/start_vlc_commander.sh &
fi

#noxbit
srt=$(ps aux | grep start_noxbit.sh | grep -v grep)
if [ "X" == "X$srt" ]
then
  /usr/iptvserver/start_noxbit.sh &
fi

#check_logs
srt=$(ps aux | grep start_check_logs.sh | grep -v grep)
if [ "X" == "X$srt" ]
then
  /usr/iptvserver/start_check_logs.sh &
fi

srt=$(ps aux | grep start_igmpproxy.sh | grep -v grep)
if [ "X" == "X$srt" ]
then
  /usr/iptvserver/start_igmpproxy.sh &
fi

#
#srt=$(ps aux | grep start | grep -v grep)
#if [ "X" == "X$srt"]
#then
#  /usr/iptvserver/start
#fi


