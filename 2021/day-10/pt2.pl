#!/usr/bin/perl

use strict;
use warnings;
use feature qw(say);
use Data::Dumper qw(Dumper);

my %M = qw'( 1 [ 2 { 3 < 4 ) 3 ] 57 } 1197 > 25137';

my $T;my @S;
while(<>) {
  chomp;
## Remove all paired brackets...
  1 while s/(\[\]|\(\)|\{\}|<>)//g;
    '' eq $_     ? 0
  : m/([\]}>)])/ ? ( $T+=$M{$1} )
  :                ( (push @S,0), map {$S[-1]=5*$S[-1]+$M{$_}} reverse split // );
}

## Find median value
say 'pt1 ',$T,"\n",'pt2 ',(sort{$a<=>$b}@S)[@S>>1];

