#!/usr/bin/perl

use strict;
use warnings;
use feature qw(say);
use Data::Dumper qw(Dumper);

my @bits;
my $c=0;
while(<>) {
  $c++;
  chomp;
  my $i=0;
  $bits[$i++] += $_ foreach split //, $_;
}

my $N = 1 << scalar @bits;
my $gamma = 0;
$gamma = ($gamma <<1) + ( (shift @bits) > $c/2 ? 1 : 0 ) while @bits;
my $epsilon = $N - 1 - $gamma;

say $epsilon * $gamma;
