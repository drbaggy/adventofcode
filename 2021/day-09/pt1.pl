#!/usr/bin/perl

use strict;
use warnings;
use feature qw(say);
use Data::Dumper qw(Dumper);

my $c = 0;
my @d;
while(<>) {
  chomp;
  push @d, [1e9, (split //), 1e9];
}

push @d, [ (1e9) x @{$d[0]} ] ;
unshift @d, [ (1e9) x @{$d[0]} ];

print Dumper( \@d );
foreach my $v ( 1 .. @d -2 ) {
  foreach my $h ( 1 .. @{$d[0]} - 2 ) {
    $c += 1 + $d[$v][$h]
      if $d[$v][$h] < $d[$v+1][$h]
      && $d[$v][$h] < $d[$v-1][$h]
      && $d[$v][$h] < $d[$v][$h+1]
      && $d[$v][$h] < $d[$v][$h-1];
  }
}

say $c;
