#!/bin/bash

isroot='sudo ';
whoami=$(whoami);
if [ "$whoami" == "root" ]
then
  isroot='';
fi

while [ "X" == "X" ]
do
   $isroot /usr/iptvserver/noxbit/STM-Hypervisor -config=/usr/iptvserver/noxbit/noxbit.cfg >> /var/log/iptvserver/noxbix.log 2>&1
done

