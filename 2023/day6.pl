#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
#use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

my($t0,$t1,$t2)=(time,0,0);

my($T, $D ) = map { join '', @{$_} } my($t,$d) = map { [m{(\d+)}g] } <>;
($t1,$t2) = (1, $T - 1 - 2 * int( ($T - sqrt ($T*$T - 4*$D ))/2 ));

$t1 *= $_ - 1 - 2 * int 1/2*($_ - sqrt($_*$_ - 4*shift @{$d})) for @{$t};

printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

