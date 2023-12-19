#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);

my($t0,$t1,$t2)=(time,0,0);

## We wrap the map in "X"s as it avoids the issues of falling of the end...
#my @e = map { chomp; [ map { [ $_, 0, 0, 0, 0 ] } split // ] } <>;
# . => 1, | -> 2, - -> 3, / -> 4, \ -> 5
$/=undef; $_=<>; chomp;
my @G = map {0+$_} split //, tr{-\r\n.|/\\}{3001245}r;

my @N = ( [],         [[0],[1],[1  ],[2,8],[2],[8]],   #1 ^
                      [[0],[2],[1,4],[2],  [1],[4]],   #2 >
          [],         [[0],[4],[  4],[2,8],[8],[2]],   #4 v
          [], [], [], [[0],[8],[1,4],[  8],[4],[1]] ); #8 <
s/\s.*//s;
my($H,@D,$x) = ( @G/(my $W=1+length), 0,-$W,1,0,$W,0,0,0,-1 );

$x = score($_),$t1||=$x,$x>$t2 && ($t2=$x) for
  map( { [$_*$W,2],[$_*$W+$W-2,8] } 0..$H-1 ),
  map( { [$_,   4],[@G-2-$_,   1] } 0..$W-2 );

sub score {
  my @q = shift;
  my @z = map { 0 } @G;

  while( @q && ( my($p,$d) = @{pop @q} ) ) {
    next if $p<0 || $p>=$#G || !$G[$p] || $z[$p] & $d;
    $z[$p]|=$d;
    push @q, map { [ $p+$D[$_], $_ ] } @{$N[$d][$G[$p]]};
  }
  0 + grep { $_ } @z
}
printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

