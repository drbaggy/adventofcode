#!/usr/bin/perl

use strict;
use warnings;
use feature qw(say);
use Data::Dumper qw(Dumper);

my $c = 0;
my %uniq = qw(2 1 3 1 4 1 7 1);
while(<>) {
  chomp;
  my @in = split;
  my @out = splice @in,-4,4;
  pop @in;
  $c += exists $uniq{ length $_ } ? 1 : 0 for @out;
}

say $c;
