#!/usr/bin/perl

use strict;
use warnings;
use feature qw(say);
use Data::Dumper qw(Dumper);

my %M = qw') 3 ] 57 } 1197 > 25137';

my $c = 0;
while(<>) {
  1 while s{(\[\]|\(\)|\{\}|<>)}{}g;
  $c+=$M{$1} if m/([\]}>)])/;
}

say $c;
