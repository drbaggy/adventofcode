#!/usr/bin/perl

use strict;
use warnings;
use feature qw(say);
use Data::Dumper qw(Dumper);

my $total = 0;
while( my $line = <>) {
  chomp $line;
  my @in  = map { join '', sort split // } split /[\s|]+/, $line;
  my @out = splice @in,-4,4;
  my @len = (['']);
  push @{$len[length $_]}, $_ for @in;
  my @digits = map { $len[$_][0] } qw(0 2 0 0 4 0 0 3 7 0);

  my ($re_1,$re_4,$re_7) = map { join '.*', split //, $digits[$_] } qw(1 4 7);
  $digits[ m{$re_4} ? 9 : m{$re_1}     ? 0 : 6 ] = $_ for @{$len[6]};
  my $re_not_6 = join '', '[^', $digits[6], ']';
  $digits[ m{$re_7} ? 3 : m{$re_not_6} ? 2 : 5 ] = $_ for @{$len[5]};

  my %map = map { $digits[$_] => $_ } 0..9;
  $total += join '', map { $map{$_} } @out;
}

say $total;

