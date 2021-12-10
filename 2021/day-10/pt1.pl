#!/usr/bin/perl

use strict;
use warnings;
use feature qw(say);
use Data::Dumper qw(Dumper);

my %M = qw') 3 ] 57 } 1197 > 25137';

my $c = 0;
while(<>) {
  ## Remove any pairs of (), {} etc...
  1 while s{(\[\]|\(\)|\{\}|<>)}{}g;
  ## Compute the score based on the first close character
  $c+=$M{$1} if m/([\]}>)])/;
}

say $c;
