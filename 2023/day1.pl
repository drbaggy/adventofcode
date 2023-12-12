#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
#use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

my($t0,$t1,$t2)=(time,0,0);

my %X;
@X{qw(one two three four five six seven eight nine)} = @X{1..9} = 1..9;

while(<>) {
  $t1 += 10*    $1  if   /(\d)/;
  $t1 +=        $1  if /.*(\d)/;
  $t2 += 10* $X{$1} if   /(\d|one|two|three|four|five|six|seven|eight|nine)/;
  $t2 +=     $X{$1} if /.*(\d|one|two|three|four|five|six|seven|eight|nine)/;
}

printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;
