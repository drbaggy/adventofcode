use strict;
use warnings;
use feature qw(say);

use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

my $time = time;
my $t = my $n = 0;

open my $fh, q(<), 'data/09.txt';
while(<$fh>) {

}
close $fh;

say "Time :", sprintf '%0.6f', time-$time;
say"$t\n$n";
