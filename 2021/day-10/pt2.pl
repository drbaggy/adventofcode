#!/usr/bin/perl

use strict;
use warnings;
use feature qw(say);
use Data::Dumper qw(Dumper);

my %M = qw'( 1 [ 2 { 3 < 4';

my @S;
while(<>) {
  chomp;
  ## Remove all paired brackets...
  1 while s{(\[\]|\(\)|\{\}|<>)}{}g;
  ## Valid or invalid
  next if !$_ || m/([\]}>)])/;
  ## Compute score for all open brackets
  push @S,0;
  $S[-1]=5*$S[-1]+$M{$_} for reverse split //;
}

## Find median value
say [sort{$a<=>$b}@S]->[@S>>1];

