#!/bin/bash

curdir=$(pwd)
cd /var/www/[ваш путь]/;
rm -f ttv.xmltv.xml.gz;
wget http://api.torrent-tv.ru/ttv.xmltv.xml.gz;
cd $curdir
