#!/usr/bin/perl
use strict;
use feature qw(say);

my ($h,$v,$a) = 0,0;
while(<>) {
  ($h+=$1,$v+=$a*$1) if m{forward (\d+)};
  $a-=$1 if m{up (\d+)};
  $a+=$1 if m{down (\d+)};
}

say $h*$v;
