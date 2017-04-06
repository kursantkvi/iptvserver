#!/bin/bash

/usr/iptvserver/start_noxbit.sh &
/usr/iptvserver/start_vlc.sh &
/usr/iptvserver/start_netserfet.sh &
/usr/iptvserver/start_vlc_commander.sh &
/usr/iptvserver/start_check_logs.sh &
/usr/iptvserver/start_igmpproxy.sh &
