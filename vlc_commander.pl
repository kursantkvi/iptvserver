#!/usr/bin/perl -w
use Net::Telnet ();
use Storable;
use Data::Dumper;
use Time::HiRes qw( usleep );

my $host="127.0.0.1";
my $port="4212";
my $password="123";


my $playdir='/tmp/iptvplay';
my $stopdir='/tmp/iptvstop';
my $wwwpath='/var/www/[ваш путь]/p.m3u';
my $glbpath='/usr/iptvserver/iptvmembers';

my $glb;
my $clients;
if (-f $glbpath) {
  $glb=retrieve($glbpath);
}

my $whoami=getpwuid($<);
my $sudo='sudo';
if ($whoami == 'root') {
  $sudo='';
}

my $in=$ARGV[0];
my $t = new Net::Telnet (Timeout => 10,
                         Prompt => '/bash\$ $/',
                         Port => $port,
                         Host => $host);
$t->open();

$t->print($password);
sleep(1);
print $t->get;



open(IN,"<$in");
open(OUT,">$wwwpath");
print OUT "#EXTM3U url-tvg=\"http://[ваш ip-адрес где все бежит]/ttv.xmltv.xml.gz\" refresh=\"3600\"\n";
my $curtime=time();
#IP ADRESS AS AAA.BBB.CCC.DDD
my ($AAA,$BBB,$CCC,$DDD)=('239','250','0',1);
my $channel=1;
while (<IN>) {
  my $row=$_;
  if ($DDD>254) {
    $CCC++;
    $DDD=1;
  }

  #INPUT ROW AS #EXTINF:-1, Первый канал (Общие)	http://192.168.100.180:8081/channels/play?id=7663 transcode tvg=!!!!!! vlc=!!!!!!
  #channel-id="34" epg-id="124" tvg-name="5 канал" pay="1" channel-id="stream-name-here" tvg-logo="http://<url to image file with logo>"
  #                     $1      $2       $3          $4       $5             $6             $7
  if ($row=~/^#EXTINF:(\S*),\s*(.*)\s+\((.*)\)\s+(http\S+)\s*(\S*)\s*tvg=!!!(.*)!!! vlc=!!!(.*)!!!\s*$/) {
    print OUT "#EXTINF:0$6,$2\n";
    print OUT "#EXTGRP:$3\n";
    print OUT "udp://@"."$AAA.$BBB.$CCC.$DDD:5500\n";
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'nonstop'}=$1;
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'name'}=$2;
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'type'}=$3;
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'input'}="$4";
    #$glb->{"$AAA.$BBB.$CCC.$DDD"}->{'play'}=0;
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'lastupdate'}=$curtime;
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'channel'}="channel".$channel;
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'udp'}="$AAA.$BBB.$CCC.$DDD";
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'transcode'}='transcode{'.$5."}:standard";
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'vlc'}=$7;
    if ((defined($glb->{"$AAA.$BBB.$CCC.$DDD"}->{'play'}) and ($glb->{"$AAA.$BBB.$CCC.$DDD"}->{'play'} == 1)) or (($glb->{"$AAA.$BBB.$CCC.$DDD"}->{'nonstop'} == 1) or ($glb->{"$AAA.$BBB.$CCC.$DDD"}->{'nonstop'} == -6))) {
      $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'play'}=1;
    } else {
      $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'play'}=0;
    }
    $DDD++;
    $channel++;
  } elsif ($row=~/^#EXTINF:(\S*),(.*)\s+\((.*)\)\s+(\/usr\/\S+)\s*(\S*)\s*tvg=!!!(.*)!!! vlc=!!!(.*)!!!\s*$/) {
    print OUT "#EXTINF:0$6,$2\n";
    print OUT "#EXTGRP:$3\n";
    print OUT "udp://@"."$AAA.$BBB.$CCC.$DDD:5500\n";
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'nonstop'}=$1;
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'name'}=$2;
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'type'}=$3;
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'input'}="$4";
    #$glb->{"$AAA.$BBB.$CCC.$DDD"}->{'transcode'}=$5 | "standard";
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'transcode'}='transcode{'.$5."}:standard";
    #$glb->{"$AAA.$BBB.$CCC.$DDD"}->{'play'}=0;
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'lastupdate'}=$curtime;
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'channel'}="channel".$channel;
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'udp'}="$AAA.$BBB.$CCC.$DDD";
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'vlc'}=$7;

    if ((defined($glb->{"$AAA.$BBB.$CCC.$DDD"}->{'play'}) and ($glb->{"$AAA.$BBB.$CCC.$DDD"}->{'play'} == 1)) or (($glb->{"$AAA.$BBB.$CCC.$DDD"}->{'nonstop'} == 1) or ($glb->{"$AAA.$BBB.$CCC.$DDD"}->{'nonstop'} == -6))) {
      $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'play'}=1;
    } else {
      $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'play'}=0;
    }
    $DDD++;
    $channel++;
  } elsif ($row=~/^#EXTINF:(\S*),(.*)\s+\((.*)\)\s+udp:\/\/(\d\S+)\s*(\S*)\s*tvg=!!!(.*)!!! vlc=!!!(.*)!!!\s*$/) {
    print OUT "#EXTINF:0$6,$2\n";
    print OUT "#EXTGRP:$3\n";
    print OUT "udp://@"."$AAA.$BBB.$CCC.$DDD:5500\n";
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'nonstop'}=$1;
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'name'}=$2;
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'type'}=$3;
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'input'}="udp://@".$4.":5500";
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'transcode'}=$5 | "standard";
    #$glb->{"$AAA.$BBB.$CCC.$DDD"}->{'play'}=0;
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'lastupdate'}=$curtime;
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'channel'}="channel".$channel;
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'udp'}="$AAA.$BBB.$CCC.$DDD";
    $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'vlc'}=$7;

    if ((defined($glb->{"$AAA.$BBB.$CCC.$DDD"}->{'play'}) and ($glb->{"$AAA.$BBB.$CCC.$DDD"}->{'play'} == 1)) or (($glb->{"$AAA.$BBB.$CCC.$DDD"}->{'nonstop'} == 1) or ($glb->{"$AAA.$BBB.$CCC.$DDD"}->{'nonstop'} == -6))) {
      $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'play'}=1;
    } else {
      $glb->{"$AAA.$BBB.$CCC.$DDD"}->{'play'}=0;
    }

    $DDD++;
    $channel++;
  #                         $1    $2       $3        $4                $5            $6             $7
  } elsif ($row=~/^#EXTINF:(\S*),(.*)\s+\((.*)\)\s+(udp:\/\/\@\S+)\s*(\S*)\s*tvg=!!!(.*)!!! vlc=!!!(.*)!!!\s*$/) {
    print OUT "#EXTINF:0$6,$2\n";
    print OUT "#EXTGRP:$3\n";
    print OUT "$4:5500\n";
    $DDD++;
    $channel++;
  }

}
close(OUT);

#INITIALAZE VLC SETTINGS
#> control channel1 stop
#> del channel1
#> new channel1 broadcast enabled
#> setup channel1 input /path/to/file_1.avi loop
#> setup channel1 output #standard{access=udp{ttl=12},mux=ts{tsid=22,pid-video=23,pid-audio=24,pid-pmt=25,use-key-frames},dst=239.255.1.1,sap,name="Channel1"}
#> control channel1 play
#$t->print("show");
#sleep(1);
#my ($channeldata)=$t->get;
#$channeldata=~tr/\n/ /;
#
#channel-id="34" epg-id="124" tvg-name="5 канал" pay="1" channel-id="stream-name-here" tvg-logo="http://<url to image file with logo>"
#
foreach my $ipaddress (sort keys (%{$glb})) {
  if (defined($glb->{$ipaddress}->{channel})) {
    if (($glb->{$ipaddress}->{'nonstop'} == -5) or ($glb->{$ipaddress}->{'nonstop'} == -6))  {
      open SHFILE, ">/usr/iptvserver/playfiles/$ipaddress.sh";
      print SHFILE "#!/bin/bash\n";
      print SHFILE "isroot=''\n";
      print SHFILE "isrootend=''\n";
      print SHFILE "whoami=\$(whoami)\n";
      print SHFILE "if [ \"\$whoami\" == \"root\" ]\n";
      print SHFILE "then\n";
      print SHFILE "  isroot=\"su totoro -c \"\n";
      print SHFILE "  isrootend=\"'\"\n";
      print SHFILE "fi\n";
      print SHFILE "while [ 1 == 1 ]\n";
      print SHFILE "do\n";
      print SHFILE "  \$isroot '/usr/iptvserver/playfiles/$ipaddress.sub.sh'\n";
      print SHFILE "done";
      close SHFILE;
      open SUBSHFILE, ">/usr/iptvserver/playfiles/$ipaddress.sub.sh";
      print SUBSHFILE "#!/bin/bash\n";
	  
	  print SUBSHFILE "/usr/bin/cvlc --miface eth1 $glb->{$ipaddress}->{vlc} --http-reconnect --loop --ttl 5 --http-user-agent 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36' -v '$glb->{$ipaddress}->{input}' --sout \"#standard{access=udp,mux=ts,dst=$ipaddress:5500,sap,name='$glb->{$ipaddress}->{name}'}\" >> /var/log/iptvserver/$ipaddress.log 2>&1\n";

      close SUBSHFILE;
      `chmod 777 /usr/iptvserver/playfiles/$ipaddress.sh`;
      `chmod 777 /usr/iptvserver/playfiles/$ipaddress.sub.sh`;
      if ($glb->{$ipaddress}->{'play'} == 1) {
        startplay($ipaddress);
      }
    } else {
      $t->print("show $glb->{$ipaddress}->{channel}");
      sleep(3);
      my ($channeldata2)=$t->get;
      if ($channeldata2=~/$glb->{$ipaddress}->{channel}\s+/) {
        $t->print("control $glb->{$ipaddress}->{channel} stop");
        $t->print("del $glb->{$ipaddress}->{channel}");
      }
      $t->print("new $glb->{$ipaddress}->{channel} broadcast enabled");
      $t->print("setup $glb->{$ipaddress}->{channel} input $glb->{$ipaddress}->{input} loop");
      $t->print("setup $glb->{$ipaddress}->{channel} output #standard{access=udp,mux=ts,dst=$ipaddress:5500,sap,name='$glb->{$ipaddress}->{name}'}");
      if (($glb->{$ipaddress}->{'play'} == 1) or ($glb->{$ipaddress}->{'nonstop'} == 1)) {
        $t->print("control $glb->{$ipaddress}->{channel} play");
        $glb->{$ipaddress}->{'play'}=time();
        print STDERR "Starting play $ipaddress\n";
        sleep(5);
        print $t->get;
      }

    }
  }
  
} 

print "Start command\n";
while(1) {
  opendir(my $stopcmd, $stopdir);
  foreach my $file (sort { $a cmp $b } readdir($stopcmd)) {
    next if ($file eq '.');
    next if ($file eq '..');
    open(FILE,"$stopdir/$file");
    my $ipaddress=(<FILE>);
    $clients->{$file}=0;
    if (defined($glb->{$ipaddress}->{'play'}) and ($glb->{$ipaddress}->{'nonstop'} != 1) and ($glb->{$ipaddress}->{'nonstop'} != -6) and (($file ne '192.168.100.1') and ($file ne '192.168.100.7') and ($file ne '192.168.100.8') and ($file ne '192.168.100.1'))) {
      print STDERR "$file go out from $ipaddress\n";
      if ($glb->{$ipaddress}->{'nonstop'} == -5) { 
        #stopplay($ipaddress);
        #$glb->{$ipaddress}->{'members'}->{$file}=0;
        #$glb->{$ipaddress}->{'play'}=0;
      } else {
        $glb->{$ipaddress}->{'members'}->{$file}=0;
        my $needstop=1;
        foreach my $value (values %{$glb->{$ipaddress}->{'members'}}) {
          $needstop=0 if ((time()-$value) < 86400);
        }
        if ($needstop == 1) {
          print STDERR "I have not members in $ipaddress. Stoping play\n";
          $t->print("control $glb->{$ipaddress}->{channel} stop");
          $glb->{$ipaddress}->{'play'}=0;
        }
      }
    }
    close(FILE);
    `$sudo rm -f $stopdir/$file`;
    print Dumper($glb->{$ipaddress});
  }
  closedir $stopcmd;
  opendir(my $playcmd, $playdir);
  foreach my $file (sort { -M $a cmp -M $b } grep !/^\.\.?$/, readdir($playcmd)) {
    next if ($file eq '.');
    next if ($file eq '..');
    open(FILE,"$playdir/$file");
    my $ipaddress=(<FILE>);
    $clients->{$file}=$ipaddress;
    if (((defined($glb->{$ipaddress}->{'play'}))and(($glb->{$ipaddress}->{'play'}==0) or (time()-$glb->{$ipaddress}->{'play'}>10))) and (($file ne '192.168.100.1') and ($file ne '192.168.100.7') and ($file ne '192.168.100.8') and ($file ne '192.168.100.1'))) {
      print STDERR "$file start play from $ipaddress\n";
      foreach my $multicastaddress (keys (%{$glb})) {
        if ($multicastaddress ne $ipaddress) {
          $glb->{$multicastaddress}->{'members'}->{$file}=0;
        }
      }
      if (($glb->{$ipaddress}->{'nonstop'} == -5) or ($glb->{$ipaddress}->{'nonstop'} == -6)) {
        startplay($ipaddress);
        $glb->{$ipaddress}->{'members'}->{$file}=time();
        $glb->{$ipaddress}->{'play'}=time();
      } else {
        $t->print("control $glb->{$ipaddress}->{channel} play");
        $glb->{$ipaddress}->{'play'}=time();
        $glb->{$ipaddress}->{'members'}->{$file}=time();
      }
    }
    close(FILE);
    `$sudo rm -f $playdir/$file`;
    print Dumper($glb->{$ipaddress});
  }
  $t->print("");
  $t->get;
  closedir $playcmd;
  foreach my $multicastaddress (sort keys (%{$glb})) {
    next if ((!defined($glb->{$multicastaddress})) or (!defined($glb->{$multicastaddress}->{'name'})) or (!defined($glb->{$multicastaddress}->{'nonstop'})) or  ($glb->{$multicastaddress}->{'nonstop'} == 1) or ($glb->{$multicastaddress}->{'nonstop'} == -6) or ($glb->{$multicastaddress}->{'play'} == 0));
    my $needplay=0;
    foreach my $members (sort keys (%{$glb->{$multicastaddress}->{members}})) {
      $needplay=1 if (defined($glb->{$multicastaddress}->{'members'}->{$members}) and ((time()-$glb->{$multicastaddress}->{'members'}->{$members}) < 600));
    }
    if ($needplay == 0)  {
      $glb->{$multicastaddress}->{play}=0;
      print STDERR "I have not members or all members not registret more 600 second on $multicastaddress. Stoping play\n";
      if (defined($glb->{$multicastaddress}->{'nonstop'}) and($glb->{$multicastaddress}->{'nonstop'} == '-5')) {
        stopplay($multicastaddress);
      } else {
        $t->print("control $glb->{$multicastaddress}->{channel} stop");
      }
      $glb->{$multicastaddress}->{'play'}=0;
    }
  }
  $t->print("");
#  print Dumper($glb);
  store $glb, $glbpath;

  sleep(3);
  $t->get;
}

sub stopplay {
  my $ip=shift;
  my $psreturn=`ps aux | grep $ip| grep -v grep`;
  my $pids='';
  my @array;
  @array=split(/\n/,$psreturn);
  foreach my $string (@array) {
    my ($pid)=$string=~/^\S+\s+(\S+)\s+/;
    $pids.=$pid." ";
  }
  if ($pids ne '') {
    print "Stoping $ip, kill pids: $pids";
    `kill -9 $pids`; 
  }
}
sub startplay {
  my $ip=shift;
  my $psreturn=`ps aux | grep $ip| grep -v grep`;
  if ($psreturn eq '') {
    system("/usr/iptvserver/playfiles/start_play.sh $ip &");
  }
}
