use strict;
use warnings;
use feature qw(say);

use Time::HiRes qw(time);

my $time = time;

## Set up direction mapper - take direction and give X + Y offsets...
## We will use math's convention here (x,y) + up is '+' rather than
## the more "IT" correct (y,x) and down is "+".

my(%v,@res) = ( 'U' => [0,1], 'D' => [0,-1],
                'R' => [1,0], 'L' => [-1,0] );

## Slurp instructions into array as will be using twice...

open my $fh, '<', 'data/09.txt';
my @lines = map { [split] } <$fh>;
close $fh;

## We want to solve the problem for a rope with 2 knots (part 1) &
## 10 knots (part 2). $K is the number of non-head knots (1 & 9
## respectively)
for my $K ( 1, 9 ) {

## Define the knot positions - all start at the origin.
  my @p = map { [0,0] } 0.. $K;

## Create a record of where the tail has been. We have to include the
## origin as we only record the position of it once it has moved...

  my %sn = ( '0/0' => 0 );

## Now we work out way through the "instructions!
  for( @lines ) {
    my($d,$l)=@{$_};

## Move the head one square at a time along the line given
    O: for (1..$l) {
      ( $p[0][0] += $v{$d}[0], $p[0][1] += $v{$d}[1] );

## Loop through knots, if knot is adjacent to previous knot - it
## doesn't move - also means other knots do
## not move....
      (    $p[$_][0] - $p[$_-1][0] < 2 && $p[$_-1][0] - $p[$_][0] < 2
        && $p[$_][1] - $p[$_-1][1] < 2 && $p[$_-1][1] - $p[$_][1] < 2
      ) ? (
## Skip the rest of the rope
        next O

## Move next knot as required
      ) : (
## Horizontal move?
        $p[$_-1][0]>$p[$_][0] ? $p[$_][0]++ : $p[$_-1][0]<$p[$_][0] && $p[$_][0]--,
## Vertical move?
        $p[$_-1][1]>$p[$_][1] ? $p[$_][1]++ : $p[$_-1][1]<$p[$_][1] && $p[$_][1]--
      ) for 1..$K;

## Mark tail square as visited
      $sn{ $p[$K][0].'/'.$p[$K][1] }++;
    }
  }

## Push result to array so can view later

  push @res, scalar values %sn;
}

say "Time :", sprintf '%0.6f', time-$time;
say for @res;
