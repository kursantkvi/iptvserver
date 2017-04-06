#!/bin/bash

for logfile in $(ls /var/log/iptvserver/ | grep 239.250 | grep -v log. | awk -F'.log' '{ print $1 }') 
do
  taildata1=$(tail -5  /var/log/iptvserver/$logfile.log | grep 'nothing to play')
  taildata2=$(tail -5  /var/log/iptvserver/$logfile.log | grep 'Resource temporarily unavailable')
  taildata3=$(tail -5  /var/log/iptvserver/$logfile.log | grep 'trying to send non-dated packet to stream output');
  taildata="$taildata1$taildata2$taildata3"
  if [ "X" != "X$taildata" ]
  then
    vlcpid=$(ps aux | grep vlc | grep $logfile | awk '{ print $2 }')
    if [ "X" != "X$vlcpid" ]
    then 
      for pid in $(ps aux | grep $logfile.sub | grep -v grep | awk '{ print $2 }') 
      do
        vlcpid="$vlcpid $pid";
      done
      if [ -f /var/log/iptvserver/$logfile.log.5 ] 
      then
        rm /var/log/iptvserver/$logfile.log.5
      fi
      if [ -f /var/log/iptvserver/$logfile.log.4 ]
      then
        mv /var/log/iptvserver/$logfile.log.4 /var/log/iptvserver/$logfile.log.5
      fi
      if [ -f /var/log/iptvserver/$logfile.log.3 ]
      then
        mv /var/log/iptvserver/$logfile.log.3 /var/log/iptvserver/$logfile.log.4
      fi
      if [ -f /var/log/iptvserver/$logfile.log.2 ]
      then
        mv /var/log/iptvserver/$logfile.log.2 /var/log/iptvserver/$logfile.log.3
      fi
      if [ -f /var/log/iptvserver/$logfile.log.1 ]
      then
        mv /var/log/iptvserver/$logfile.log.1 /var/log/iptvserver/$logfile.log.2
      fi
      if [ -f /var/log/iptvserver/$logfile.log ]
      then
        mv /var/log/iptvserver/$logfile.log /var/log/iptvserver/$logfile.log.1
      fi
    
      kill -9 $vlcpid
      timestamp=$(date);
      echo "$timestamp: restart $logfile. Kill $vlcpid"

    fi
  fi
done
taildata=$(tail -15  /var/log/iptvserver/noxbix.log | grep 'Error Start');
#taildata2=$(tail -100 /var/log/iptvserver/noxbix.log | grep 'peer_disconnected_alert' | grep 'disconnecting');

if [ "X" != "X$taildata" ]
#if [ "X" != "X$taildata$taildata2" ]
then
  if [ -f /var/log/iptvserver/noxbix.log.5 ] 
  then
    rm /var/log/iptvserver/noxbix.log.5
  fi
  if [ -f /var/log/iptvserver/noxbix.log.4 ]
  then
    mv /var/log/iptvserver/noxbix.log.4 /var/log/iptvserver/noxbix.log.5
  fi
  if [ -f /var/log/iptvserver/noxbix.log.3 ]
  then
    mv /var/log/iptvserver/noxbix.log.3 /var/log/iptvserver/noxbix.log.4
  fi
  if [ -f /var/log/iptvserver/noxbix.log.2 ]
  then
    mv /var/log/iptvserver/noxbix.log.2 /var/log/iptvserver/noxbix.log.3
  fi
  if [ -f /var/log/iptvserver/noxbix.log.1 ]
  then
    mv /var/log/iptvserver/noxbix.log.1 /var/log/iptvserver/noxbix.log.2
  fi
  if [ -f /var/log/iptvserver/noxbix.log ]
  then
    mv /var/log/iptvserver/noxbix.log /var/log/iptvserver/noxbix.log.1
  fi
  hypervisorpid=$(ps aux |grep STM-Hyperv | grep -v grep | awk '{ print $2 }') 
  downloadpid=$(ps aux |grep STM-Downloader | grep -v grep | awk '{ print $2 }')
  timestamp=$(date);
  echo "$timestamp: kill noxbit pids: hypervisor $hypervisorpid and downloader $downloadpid";
  kill -9 $hypervisorpid $downloadpid
fi
