#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
use List::Util qw(max);
use Time::HiRes qw(time);

my($t0,$t1,$t2)=(time,0,0);

while(<>) {
  $t2 += ( my $r = max m{(\d+) red}g   )
       * ( my $b = max m{(\d+) blue}g  )
       * ( my $g = max m{(\d+) green}g );
  $t1 += $1 if $r <= 12 && $g <= 13
            && $b <= 14 && m{(\d+)}
}

printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

