use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
my $time = time;

my $t = my $n = 0;

## Do stuff here...

say "\nTime :", sprintf '%0.6f', time-$time;
say"$t\n$n";
