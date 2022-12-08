use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
my $time = time;

my $t = my $n = 0;

## First we read in our grid and create an
## array of arrays `@`

my @g;
open my $fh, '<', 'data/08.txt';
while(<$fh>){
  chomp;
  push @g,[ split // ];
}

my( $h, $w ) = ( $#g, @{$g[0]} -1 );

## Skip edge trees as we know the either the "distance" is 0
## and the visiblity is 1 - so doesn't affect distance calc
## and we can note the sum of visible external trees is
##    2 x h x w - 4
## or
##    2 * $h * $w
## as we already subtract 1 from each...

## For other trees, we start at the tree and work outwards. If
## we hit a tree taller OR as tall the current tree we stop
## counting and flag that the tree is not visible from that
## direction. We exit the loop where we hit a tree taller or
## as tall...

## Once we have looked in all for directions from the tree
## we (1) compute the score for part 2 by multiplying
##        together the 4 distances...
##    (2) count the tree as visible (any flag is not set)

$t = 2*($h+$w);

for my $y (   1 .. $h-1 ) {
  for my $x ( 1 .. $w-1 ) {
    my ( $m, $f, @s )=( $g[$y][$x], 0, 0, 0, 0, 0 );
    $s[0]++, ($g[$_][$x] >= $m) && ($f|=1) && last for reverse    0 .. $y-1;
    $s[1]++, ($g[$_][$x] >= $m) && ($f|=2) && last for         $y+1 .. $h;
    $s[2]++, ($g[$y][$_] >= $m) && ($f|=4) && last for reverse    0 .. $x-1;
    $s[3]++, ($g[$y][$_] >= $m) && ($f|=8) && last for         $x+1 .. $w;
    my $p = $s[0] * $s[1] * $s[2] * $s[3];
    $n = $p if     $n <  $p;
    $t++    unless $f == 15;
  }
}

say "\nTime :", sprintf '%0.6f', time-$time;
say"$t\n$n";
