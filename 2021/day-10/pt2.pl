#!/usr/bin/perl

use strict;
use warnings;
use feature qw(say);
use Data::Dumper qw(Dumper);

my %M = qw'( 1 [ 2 { 3 < 4';

my @S;
while(<>) {
  chomp;
  1 while s{(\[\]|\(\)|\{\}|<>)}{}g;
  next if !$_ || m/([\]}>)])/;
  push @S,0;
  $S[-1]=5*$S[-1]+$M{$_} for reverse split //;
}
say [sort{$a<=>$b}@S]->[@S>>1];

