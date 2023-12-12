#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
#use Data::Dumper qw(Dumper);
use Time::HiRes qw(time);

my($t0,$t1,$t2)=(time,0,0);

my (@l,$t,@r,$s,@m)=<>;
push @l, '';

my   @v = my @n = (shift @l) =~ m{(\d+)}g;
push @r, [$s,$s+$t-1] while ($s,$t)=splice @n,0,2;
shift @l;

for(@l) {
  unless( m{\S} ) {
    @v = map { [ $t = $_, ## part 1
      map { $t>=$_->[0] && $t<=$_->[1] ? $t+$_->[2] : () } @m
    ]->[-1] } @v;
    for my $r ( @r ) { ## part 2
      my( $st, @x ) = ( $r->[0]-1, [ $r->[1]+1, 0 ] );
      push( @x, [ $_->[0] > $r->[0] ? $_->[0] : $r->[0],
                  $_->[1] > $r->[1] ? $r->[1] : $_->[1] ] ) &&
      push( @n, [ $x[-1][0]+$_->[2], $x[-1][1]+$_->[2] ] )
        for grep { $_->[0] <= $r->[1] && $r->[0] <= $_->[1] } @m;
      push @n, map { ( $t, $st ) = ( $st + 1, $_->[1] );
        $t < $_->[0] - 1 ? [ $t, $_->[0] - 1 ] : () }
        sort { $a->[0] <=> $b->[0] } @x;
    }
    (@r,@m,@n) = @n;
  }
## Add to map
  push @m, [ $2, $2+$3-1, $1-$2 ] if m{(\d+) (\d+) (\d+)};
}

$t1 =  shift @v      ; $_      < $t1 && ($t1 = $_     ) for @v;
$t2 = [shift @r]->[0]; $_->[0] < $t2 && ($t2 = $_->[0]) for @r;

printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

