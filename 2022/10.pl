use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
my $time = time;

my($p,$x,$z,$t,$n)=(1,1,40,0,'');

open my $fh, q(<), 'data/10.txt';
o(),/addx (\S+)/&&(o(),$x+=$1) while <$fh>;
close $fh;

sub o {
  $t += $p*$x if $z == 19;
  $n .= ($z?'':"\n").(abs($z-$x)<2?'#':'.');
  $p ++;
  $z ++;
  $z %=40;
}

say "Time :", sprintf '%0.6f', time-$time;
say"$t\n$n";
