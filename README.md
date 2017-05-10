# iptvserver
Multicast server over VLC 

По файлам:
  Запуск:
    startup.sh - скрипт запуска всего (прописан в rc.local)
    start_noxbit.sh - запуск нокса
    start_vlc.sh - запуск vlc в виде сервера с telnet интерфейсом
    start_netserfet.sh - запуск слушателя подписок
    start_vlc_commander.sh - запуск системы управления
    start_check_logs.sh - запуск системы парсенга логов (в свою очередь перезапускает подвисшие компоненты службы)
    start_igmpproxy.sh - запуск igmpproxy (как же мы без мультикаста от провайдера)

  Перезапуск
    restart_iptv.sh - перезапуск всех компонент

  Сами скрипты:
    netserfet.pl - слушатель подписок мультикаста
    vlc_commander.pl - система управления vlc

  Самодиагностика:
    check_logs.sh - парсер логов
    check_startup_scripts.sh - проверка что все запущено (работает по крону)

  playlist.m3u - пример входного плейлиста.

  
Зависимости PERL
  Net::PcapUtils;
  NetPacket::Ethernet;
  NetPacket::IP;
  NetPacket::IGMP;
  Data::Dumper;
  Net::Telnet
  Storable;
  Time::HiRes;