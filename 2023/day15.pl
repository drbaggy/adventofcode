#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
#use Data::Dumper qw(Dumper);

my($t0,$t1,$t2)=(time,0,0);

## We wrap the map in "X"s as it avoids the issues of falling of the end...
my @b = map { []               } 0..255;
my @e = map { chomp; split /,/ } <>;
O: for(@e) {
  my($bn,$l,$o,$x) = (0,split /([-=])/);
  $bn    = 17*($bn+ord   ) for split//,$l;     ## Box number
  $bn   &= 255;
  my $sc = 17*($bn+ord $o);
  $sc    = 17*($sc+ord   ) for split//,$x//''; ## And score
  $t1   += $sc&255; ## Part 1 here - Part 2 below
  $b[$bn] = [ grep { $_->[0] ne $l } @{$b[$bn]} ], next if $o eq '-'; # delete
  ($_->[0] eq $l) && ($_->[1] = $x,next O) for @{$b[$bn]};            # replace
  push @{$b[$bn]},[$l,$x];                                            # add
}
for my $x (0..255) {
  $t2+=($x+1)*($_+1)*$b[$x][$_][1] for 0 .. $#{$b[$x]};
}

printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

