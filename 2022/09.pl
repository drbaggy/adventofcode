use strict;
use warnings;
use feature qw(say);

use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

my $time = time;

my(%v,@res) = ( 'U' => [0,1], 'D' => [0,-1],
                'R' => [1,0], 'L' => [-1,0] );

open my $fh, '<', 'data/09.txt';
my @lines = <$fh>;
close $fh;

for my $K ( 1, 9 ) {  ## 2 & 10 knots
  my @p = map { [0,0] } 0.. $K;
  my %seen = ( '0/0' => 0 );
  for( @lines ) {
    my($d,$l)=split;
    O: for (1..$l) {
      ( $p[0][0] += $v{$d}[0], $p[0][1] += $v{$d}[1] );
      (    $p[$_][0] - $p[$_-1][0] < 2
        && $p[$_-1][0] - $p[$_][0] < 2
        && $p[$_][1] - $p[$_-1][1] < 2
        && $p[$_-1][1] - $p[$_][1] < 2
      ) ? (
        next O
      ) : (
        $p[$_-1][0]>$p[$_][0] && $p[$_][0]++,
        $p[$_-1][1]>$p[$_][1] && $p[$_][1]++,
        $p[$_-1][0]<$p[$_][0] && $p[$_][0]--,
        $p[$_-1][1]<$p[$_][1] && $p[$_][1]--
      ) for 1..$K;
      $seen{ $p[$K][0].'/'.$p[$K][1] }++;
    }
  }
  push @res, scalar values %seen;
}
say "Time :", sprintf '%0.6f', time-$time;
say for @res;
