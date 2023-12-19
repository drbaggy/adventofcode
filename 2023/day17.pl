#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
#use Data::Dumper qw(Dumper);

my($t0,$t1,$t2)=(time,0,0);

## Convert map into numeric array of weights..., get dimensions
my @g = map { chomp; [ map {0+$_} split // ] } <>;
my($H,$W) = ( scalar @g, scalar @{$g[0]} );

($t1,$t2) = ( solve( 0, 3 ), solve( 4, 10 ) );

printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

sub solve {
  my @B = map { [ map { 1e9 } @{$_} ] } @g; ## Caches of vertical/horizontal visits
  my @C = map { [ map { 1e9 } @{$_} ] } @g; ## to locations - lowest loss to reach
  ($B[0][0],$C[0][0], my($min,$max,@Q)) = (0,0, @_,[ 0, 0, 0 ], [ 0, 0, 1 ] );
  while( @Q && ( my($r,$c,$d) = @{shift @Q} ) ) {
    if( $d ) {
      my $t = my $s = $C[$r][$c]; ## We are now going to try horizontal moves
      $s+=$g[$r][$c-$_], ($_ >= $min && $s < $B[$r][$c-$_]) && ($B[$r][$c-$_]=$s, push @Q, [ $r, $c-$_, 0 ]) for 1 ..  $max < $c        ? $max :  $c;
      $t+=$g[$r][$c+$_], ($_ >= $min && $t < $B[$r][$c+$_]) && ($B[$r][$c+$_]=$t, push @Q, [ $r, $c+$_, 0 ]) for 1 .. ($max < ($W-$c-1) ? $max : ($W-$c-1));
    } else {
      my $t = my $s = $B[$r][$c]; ## We are now going to try vertical moves
      $s+=$g[$r-$_][$c], ($_ >= $min && $s < $C[$r-$_][$c]) && ($C[$r-$_][$c]=$s, push @Q, [ $r-$_, $c, 1 ]) for 1 ..  $max < $r        ? $max :  $r;
      $t+=$g[$r+$_][$c], ($_ >= $min && $t < $C[$r+$_][$c]) && ($C[$r+$_][$c]=$t, push @Q, [ $r+$_, $c, 1 ]) for 1 .. ($max < ($H-$r-1) ? $max : ($H-$r-1));
    }
  }
  $B[-1][-1] < $C[-1][-1] ? $B[-1][-1] : $C[-1][-1]
}

