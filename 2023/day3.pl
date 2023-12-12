#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
#use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

my($t0,$t1,$t2)=(time,0,0);

my(@grid,@n) = grep { $_ } map { s{\s+$}{}r } <>; ## Tidy up grid...

## Part 1 - we are looking for symbols beside numbers - if there
## is one we include the number int eht title....

for my $r (0..$#grid) {
  my($x, @p) = (0,split m{(\d+)}, $grid[$r]);
  while(@p>1) {
    $x += length shift @p;
    my($S,$L) = ( $x ? $x-1 : 0, ( $x ? 2 : 1 ) + length $p[0] );
    push @{$n[$r]}, [ $S, $S + $L - 1, $p[0] ];
    $t1 += $p[0] if   substr( $grid[$r  ], $S, $L ) =~ m{[^\d.]}
      || $r>0      && substr( $grid[$r-1], $S, $L ) =~ m{[^\d.]}
      || $r<$#grid && substr( $grid[$r+1], $S, $L ) =~ m{[^\d.]};
    $x += length shift @p;
  }
}

## Part 2 - we now need to look for all stars and find neighbouring stars
$n[@grid]=[];

for my $r (0..$#grid) {
  my($x,@p) = ( 0, split m{(\*)}, $grid[$r] );
  while(@p>1) {
    $x += length shift @p;
    my($c,$z)=(0,1);
       $_->[0]   <= $x
    && $x        <= $_->[1]
    && ( $z      *= $_->[2] )
    &&         $c++
    && ( $t2     += $z )
    && last
      for @{$n[$r-1]}, @{$n[$r]}, @{$n[$r+1]};
    $x += length shift @p;
  }
}

printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

