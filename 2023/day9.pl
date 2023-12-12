#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
#use Data::Dumper qw(Dumper);

my($t0,$t1,$t2)=(time,0,0);
my($p,@C,@n) = (0,
  1,-21,210,-1330,5985,-20349,54264,
  -116280,203490,-293930,352716,-352716,
  293930,-203490,116280,-54264,20349,
  -5985,1330,-210,21,-1
);

for(<>) {
  $n[$p++]+=$_ for split;
  $p=0;
}

$t1 += $_*$C[$p++], $t2 -= $_*$C[$p] for @n;

printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

