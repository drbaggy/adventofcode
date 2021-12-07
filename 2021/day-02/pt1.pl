#!/usr/bin/perl
use strict;
use feature qw(say);

my ($h,$v) = 0,0;
while(<>) {
  $h+=$1 if m{forward (\d+)};
  $v-=$1 if m{up (\d+)};
  $v+=$1 if m{down (\d+)};
}

say $h*$v;
