#!/usr/bin/perl 

use strict;
use Net::PcapUtils;
use NetPacket::Ethernet qw(:strip);
use NetPacket::IP;
use NetPacket::IGMP;
use Data::Dumper;
use IO::Socket::INET;

my $playdir='/tmp/iptvplay';
my $stopdir='/tmp/iptvstop';
my $interface="XXX";                   # LISTENING port     / Порт на котором слушаем мультикаст-запросы 

my $host = 'localhost';
my $port = XXXX;                       # VLC_COMMANDER port / Порт сервера с vlc_commander
my $server = "aaa.bbb.ccc.ddd";        # VLC_COMMANDER host / IP-адрес хоста с vlc_commander

my $restart_address='eee.fff.ggg.hhh'; # RESTART MCAST addr / Мультикаст адрес, вызов которого приведет к перезагрузке всей системы вещания


if (!(-d $playdir)) {
  `mkdir $playdir`;
}
if (!(-d $stopdir)) {
  `mkdir $stopdir`;
}

our $lastrestart=0;

sub process_pkt {
    my($arg, $hdr, $pkt) = @_;

    my $ip_obj = NetPacket::IP->decode(eth_strip($pkt));
    my $igmp_obj = NetPacket::IGMP->decode($ip_obj->{data});

    my $socket = new IO::Socket::INET (
        PeerHost => $server,
        PeerPort => $port,
        Proto => 'tcp',
    );
    die "cannot connect to the server $!\n" unless $socket;
    print "connected to the server\n";

    if ($igmp_obj->{'group_addr'}=~/$restart_address/) {
      my $cur_time=time();
      if ($cur_time-$lastrestart>120) {
        `/usr/iptvserver/restart_iptv.sh force`;
        $lastrestart=$cur_time;
        my $req = 'rstr:0.0.0.0:0.0.0.0';
        my $size = $socket->send($req);
        print "sent data of length $size\n";
      }
    }
    
    if (!($igmp_obj->{'group_addr'}=~/239\.250\.\d+\.\d+/)) {
        my $req = 'ping:0.0.0.0:0.0.0.0';
        my $size = $socket->send($req);
    } else {
#      return if ((!($ip_obj->{dest_ip} eq '224.0.0.22')) or (!($ip_obj->{dest_ip}=~/239.250.0/)));

#      return if (scalar(@gaddrfull)<9);
#      my $gaddr = join('.',unpack('x12C4',$ip_obj->{data}));
#      my $cmd = join('.',unpack('x8C1',$ip_obj->{data}));
#      return if ($ip_obj->{src_ip} eq '192.168.100.7');

      
      print STDERR ("$ip_obj->{src_ip} -> $ip_obj->{dest_ip} \n",
            "$igmp_obj->{type}/$igmp_obj->{subtype} \n",
            "$igmp_obj->{group_addr}\n");

      if ($ip_obj->{dest_ip} == $igmp_obj->{group_addr}) {
      	open(FILE,">$playdir/$ip_obj->{src_ip}");
          print FILE "$igmp_obj->{group_addr}";
          close(FILE);
          my $req = "strt:$ip_obj->{src_ip}:$igmp_obj->{group_addr}";
          my $size = $socket->send($req);
          print "sent data of length $size\n";

      } elsif ($ip_obj->{dest_ip} == '224.0.0.2') {
          open(FILE,">$stopdir/$ip_obj->{src_ip}");
          print FILE "$igmp_obj->{group_addr}";
          close(FILE);
          print SOCKET "stop:$ip_obj->{src_ip}:$igmp_obj->{group_addr}";
          my $req = "stop:$ip_obj->{src_ip}:$igmp_obj->{group_addr}";
          my $size = $socket->send($req);
          print "sent data of length $size\n";

      }
    }
    shutdown($socket, 1);
    $socket->close();
}

Net::PcapUtils::loop(\&process_pkt,DEV=>$interface, FILTER => 'igmp');
