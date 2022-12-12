use strict;
use warnings;
use feature qw(say);

use Time::HiRes qw(time);

my $time = time;

## Set up direction mapper - take direction and give X + Y offsets...
## We will use math's convention here (x,y) + up is '+' rather than
## the more "IT" correct (y,x) and down is "+".

my(%v,@r) = ('U'=>[0,1],'D'=>[0,-1],'R'=>[1,0],'L'=>[-1,0]);

## Slurp instructions into array as will be using twice...

my$fn=__FILE__=~s/[^\/]*$//r.'../data/09.txt';1while($fn=~s/[^\/]*\/\.\.\///);
open my $fh, '<', $fn;
my @l = map { / / && [ @{$v{$`}}, 0+$' ] } <$fh>;
close $fh;

## We want to solve the problem for a rope with 2 knots (part 1) &
## 10 knots (part 2). $K is the number of non-head knots (1 & 9
## respectively)
for my $K ( 1, 9 ) {

## Define the knot positions - all start at the origin.
  my($h,@p) = map {[0,0]} 0..$K;

## Create a record of where the tail has been. We have to include the
## origin as we only record the position of it once it has moved...
  my %s = ('0 0'=>0);

## Now we work out way through the "instructions!
  for (@l) {

## Move the head one square at a time along the line given
    my($d,$e,$l)=@{$_};
    O: for ( 1..$l ) {
      ( $h->[0] += $d, $h->[1] += $e );
      my $p = $h;

## Loop through knots, if knot is adjacent to previous knot - it
## doesn't move - also means other knots do
## not move....
## Skip the rest of the rope if too close together
      abs($p->[0]-$_->[0]) < 2 && abs($p->[1]-$_->[1]) < 2 ? next O :

## Horizontal move?
      ( $p->[0]>$_->[0] ? $_->[0]++ : $p->[0]<$_->[0] && $_->[0]--,

## Vertical move?
        $p->[1]>$_->[1] ? $_->[1]++ : $p->[1]<$_->[1] && $_->[1]--,
        $p=$_ ) for @p;

## Mark tail square as visited
      $s{ "@{$p}" }++;
    }
  }
## Push result to array so can view later
  push @r, scalar values %s;
}

say "Time :", sprintf '%0.6f', time-$time;
say for @r;
