#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
#use Data::Dumper qw(Dumper);

my($t0,$t1,$t2)=(time,0,0);

my $set = @ARGV ? shift @ARGV : 'input/day21.test';

my %challenges = (
  'input/day21.test' => [ [    6,        16 ], [    10,      50 ], [   50,       1_594 ], [ 100, 6_536 ],
                          [  500,   167_004 ], [ 1_000, 668_697 ], [ 5_000, 16_733_044 ], [  82,   999 ], ],
  'input/day21.txt'  => [ [   64,     3_671 ], [     26_501_365,   609_708_004_316_870 ],                 ],
);

open my $fh, '<', $set;
  my @l = map { [ map { [] }   @{$_} ] }
  my @g = map { chomp; [  split//,$_ ]  } grep { /\S/ } <$fh>;
close $fh;

my $R = @g; my $C = @{$g[0]};
my $P=10;
my @DIR = ( [ [-2, 0], [-1, 0] ], [ [ 2, 0], [ 1, 0] ],                 [ [ 0,-2], [ 0,-1] ], [ [ 0, 2], [ 0, 1] ],
            [ [ 1, 1], [ 0, 1],[ 1, 0] ], [ [-1, 1], [ 0, 1],[-1, 0] ], [ [ 1,-1], [ 0,-1],[ 1, 0] ], [ [-1,-1], [ 0,-1],[-1, 0] ], );
## Compute the valid 2 step paths!

## Generate a list of directions of travel from each node....
my($r,$c)=(0,0);
for my $t (0..$R-1) {
  for my $x (0..$C-1) {
    ($r,$c)=($t,$x) if $g[$t][$x] eq 'S';
    for(@DIR) {
      my($d,$e,$f) = @{$_};
      my ($u,$v) = ( ($t+$d->[0])%$C, ($x+$d->[1])%$R );
      next if $g[ $u ][ $v ] eq '#';
      next if ( $f ? $g[($t+$f->[0])%$R][($x+$f->[1])%$C] eq '#' : 1 )
           &&        $g[($t+$e->[0])%$R][($x+$e->[1])%$C] eq '#';
      push @{$l[$t][$x]}, $d;
    }
  }
}

for my $chall (@{$challenges{$set}}) {
  my @score;
  my( $S, $VAL ) = @{$chall};
  my @to_check = $S <= ($S%(2*$R)+2*$R*5) ? $S : ( map { $S%(2*$R) + 2*$R * $_ } 3,4,5 );
  my $s_offset = $S % (2*$R);
  my $index    = int ( $S/2/$R );
  my @t = map { [ map { $S+2 } 1..($P*2+1)*$C+2 ] } 1..(2*$P+1)*$R+2;
  ## Compute start points - if are looking for an odd number of steps we include all the adjacent squares
  ## o/w we just have the start point...
  my @pts = $S%2 ? ( $g[$r+1][$c] eq '.' ? [$r+1,$c] : (), $g[$r-1][$c] eq '.' ? [$r-1,$c] : (),
                     $g[$r][$c+1] eq '.' ? [$r,$c+1] : (), $g[$r][$c-1] eq '.' ? [$r,$c-1] : () )
                 : [$r,$c]
                 ;
  ## Set "time" for start points to 0/1
  my $l = $S%2;
  $t[ $_->[0] += $P*$R ][ $_->[1] += $P*$C ] = $l for @pts;
  for my $O ( @to_check ) {
    while( $l < $O + 2 ) {
      $l += 2;
      my @z = ();
      for my $p (@pts) {
        for( @{$l[ $p->[0]%$R ][ $p->[1]%$C ]} ) {
          my($u,$v)=($_->[0]+$p->[0], $_->[1]+$p->[1] );
          next if $t[ $u ][ $v ] <= $l;
          $t[$u][$v]=$l;
          push @z,[$u,$v];
        }
      }
      @pts = @z;
    }
    push @score, [ $O, score($O,\@t) ];
  }
  if( scalar @score < 2 ) {
    $t1 = $score[0][1];
  } else {
    my $a2 = $score[2][1]-2*$score[1][1]+$score[0][1];
    my $a1 = $score[1][1] - $score[0][1]-$a2*3;
    my $a0 = $score[0][1] - 3 * $a2 - 3 * $a1;
    $a2/=2; $a1-=$a2;
    $t2 = $a2*$index*$index + $a1 * $index + $a0;
  }
}

sub score {
  my $S = shift;
  scalar grep { $_ <= $S} map{ @{$_} } @{$_[0]};
}

printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

