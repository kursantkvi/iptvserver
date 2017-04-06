#!/bin/bash

while [ 'x' == 'x' ]
do
  /usr/iptvserver/check_logs.sh >> /var/log/iptvserver/check_logs.log
  sleep 1
done
