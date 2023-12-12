#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
#use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

my($t0,$t1,$t2)=(time,0,0);

my($c,$k) = (0,0);

my @in =
  map  {
    my %f; $f{$_}++ for split //,$_->[0];
    my $v = join '', reverse sort values %f;
    my $j = delete $f{'b'}//0;
    my @t = reverse sort values %f;
    $t[0] += $j;
    [ $_->[1], $_->[0], $v, join '', @t ]
  }
  map  { $_->[0] =~ y/TJQKA/abcde/; $_ }
  map  { [m{(\w+)}g] } <>;

$t1 += $_->[0]*++$c for
  sort { $a->[2] cmp $b->[2] || $a->[1] cmp $b->[1] }
  @in;

$t2 += $_->[0]*++$k for
  sort { $a->[3] cmp $b->[3] || $a->[1] cmp $b->[1] }
  map { $_->[1]=~y/b/1/; $_ }
  @in;

printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

