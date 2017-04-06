#!/usr/bin/perl 

use strict;
use Net::PcapUtils;
use NetPacket::Ethernet qw(:strip);
use NetPacket::IP;
use NetPacket::IGMP;
use Data::Dumper;

my $playdir='/tmp/iptvplay';
my $stopdir='/tmp/iptvstop';

if (!(-d $playdir)) {
  `mkdir $playdir`;
}
if (!(-d $stopdir)) {
  `mkdir $stopdir`;
}

sub process_pkt {
    my($arg, $hdr, $pkt) = @_;

    my $ip_obj = NetPacket::IP->decode(eth_strip($pkt));
    my $igmp_obj = NetPacket::IGMP->decode($ip_obj->{data});
    return if (!($igmp_obj->{'group_addr'}=~/239\.250\.\d+\.\d+/));

    
    print STDERR ("$ip_obj->{src_ip} -> $ip_obj->{dest_ip} \n",
          "$igmp_obj->{type}/$igmp_obj->{subtype} \n",
          "$igmp_obj->{group_addr}\n");
    if ($ip_obj->{dest_ip} == $igmp_obj->{group_addr}) {
    	open(FILE,">$playdir/$ip_obj->{src_ip}");
        print FILE "$igmp_obj->{group_addr}";
        close(FILE);
    } elsif ($ip_obj->{dest_ip} == '224.0.0.2') {
        open(FILE,">$stopdir/$ip_obj->{src_ip}");
        print FILE "$igmp_obj->{group_addr}";
        close(FILE);
    }
}

Net::PcapUtils::loop(\&process_pkt,DEV=>'eth1', FILTER => 'igmp');
