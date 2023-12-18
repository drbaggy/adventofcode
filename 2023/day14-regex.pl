#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);

my($t0,$t1,$t2)=(time,0,0);

$/=undef;
my $c = length [(my$M=<>)=~/(\S+)/]->[0];
my $r = int 1/($c+1)*(1 + length $M);

my( $U, $D, $f, $s, @S, %C ) =
  ( "[.](.{$c}(?:[.].{$c})*)O", "(.*)O(.{$c}(?:[.].{$c})*)[.]", $r );

1 while $M =~ s/$U/O$1./s; # Roll north
$t1+=$f--*y/O/O/ for split /\s+/, $M; # Compute score
for (1..1e9) {
  1 while $M =~ s/([.]+)O/O$1/s; # Roll west
  1 while $M =~ s/$D/$1.$2O/s;     # Roll south
  1 while $M =~ s/O([.]+)/$2O/s; # Roll east  #V seen before?
  $t2 = $S[ $C{$M} + (1e9-$_-1)%($_-$C{$M}) ], last if $C{$M};
  ($C{$M},$s,$f)=($_,0,$r);            # Store time seen layout
  $s+=$f--*y/O/O/ for split /\s+/, $M; # Compute score
  push @S,$s;                          #   & store
  1 while $M =~ s/$U/O$1./s;     # Roll north
}

printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

