#!/usr/bin/perl

use strict;
use warnings;
use feature qw(say);
use Data::Dumper qw(Dumper);

my $c = 0;
my $N = 1000;
my @offsets = (-$N-1,-$N,-$N+1,-1,0,1,$N-1,$N,$N+1);
my @pts = map { 0 } 1..$N*$N;
while(<>) {
  my($x,$y,$X,$Y) = m{(\d+),(\d+) -> (\d+),(\d+)};
  next if $x!=$X && $y!=$Y;
  my $len = $x==$X ? abs($Y-$y) : abs($X-$x);
  my $dir = $offsets[ ($Y<=>$y)*3 + ($X<=>$x) + 4 ];
  $pts[$x+$y*$N+$dir*$_]++ foreach 0..$len;
}

say scalar grep {$_>1} @pts;
