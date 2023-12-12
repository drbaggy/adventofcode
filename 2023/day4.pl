#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
#use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

my($t0,$t1,$t2)=(time,0,0);

my($i,@n)=(0);

for(<>) {
  $n[0]       ++;
  my($l,$r,%x) = map { [split] } m{:\s+(.*)\s+\|\s+(.*)\s*$};
  @x{@{$l}}    = 1;
  $n[$_]      += $n[0] for 1..( my $t = grep{exists $x{$_}} @{$r} );
  $t2         += shift @n;
  $t1         += 1 << $t-1;
}

printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

