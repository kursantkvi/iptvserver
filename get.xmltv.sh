#!/bin/bash


# путь до файла
TTVPATH=/var/www/ttv/

rm -f $TTVPATH/ttv.xmltv.xml.gz;
wget http://api.torrent-tv.ru/ttv.xmltv.xml.gz -O $TTVPATH/ttv.xmltv.xml.gz


