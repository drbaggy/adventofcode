#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
#use Data::Dumper qw(Dumper);

my($t0,$t1,$t2)=(time,0,0);

## Lookups....
my @O = ( [-1,0], [0,1], [1,0], [0,-1] );
my @D = (
  { '|' => 0, 'F' => 1,           '7' => 3 },
  { 'J' => 0, '-' => 1, '7' => 2,          },
  {           'L' => 1, '|' => 2, 'J' => 3 },
  { 'L' => 0,         , 'F' => 2, '-' => 3 },
);

my @g = map { chomp; [ '.',(split//), '.'] } <>;
my (@b,$i,$j,$t,$u) = ('.')x@{$g[0]};
unshift @g, [ @b ];
push    @g, [ @b ];

## Find start point...
O: for my $l ( 0..$#g ) {
  $g[$l][$_] eq 'S' && ($t=$i=$l,$u=$j=$_) && last O for 0..$#{$g[0]};
}
## Find the pipe under the S and initial direction
$g[$i][$j]=[qw(. . . L . | F . . J - . 7 . . .)]->[
  ({'|'=>1,'7'=>1,'F'=>1}->{$g[$i-1][$j]}//0)+ # pipe above
  ({'-'=>2,'7'=>2,'J'=>2}->{$g[$i][$j+1]}//0)+ # pipe right
  ({'|'=>4,'L'=>4,'J'=>4}->{$g[$i+1][$j]}//0)+ # pipe below
  ({'-'=>8,'F'=>8,'L'=>8}->{$g[$i][$j-1]}//0)
]; # pipe left
my $d = exists $D[2]{$g[$i][$j]} ? 0 :
        exists $D[3]{$g[$i][$j]} ? 1 : 2; ## Direction up, right, down
## We are going to make a map of the line.... Start with a blank map..
#my @g2 = map { [ @b ] } @g;

## Start we need to work out one of the directions...
## Keeping count of steps
do {
  $i+=$O[$d][0],
  $j+=$O[$d][1],
  $t1++,
  $d = $D[$d]{ $g[$i][$j] },
  $g[$i][$j] =~ y/-7|JLF/123456/;
} until $t==$i && $u==$j;

## Now we count the numbers of cells inside the loop..
## To be inside - if you walk from left you have to have crossed
## the loop and odd number of times..
## If you see | or F---J or L---7 you cross the line;
## F---7 or L--J is NOT a crossing.
$i=0;
for ( @g ) {
  ## Remove horizontal pipes, split when pipe crosses line
  $t2+= (++$i)&1 && length $_ for '',split /(?:64|52|3)/, ( join '', grep { $_ ne '1' } @{$_} )=~ s/(62|54)//gr;
}
$t1 /= 2; ## Mid point

printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

