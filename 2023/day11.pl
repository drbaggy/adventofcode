#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);

my($t0,$t1,$t2)=(time,0,0);
my($E,$c,$k,@l,@p1,@p2,@p3,@p4) = (1_000_000,0,0,<>);
chomp @l;

my @v = map { [ $c += /#/?1:2, $k += /#/?1:$E ] } @l;

while( length $l[0] ) {
  my( $f, $f2 ) = ( 2, $E );
  substr($l[$_],0,1,'') eq '#' &&
    ( $f2=$f=1, (push @p1, $c),
                (push @p2, $k),
                (push @p3, $v[$_][0]),
                (push @p4, $v[$_][1]) )
      for 0..$#l;
  $c += $f, $k += $f2;
}

$t1 = dsum(\@p1,\@p3);
$t2 = dsum(\@p2,\@p4);

sub dsum {
  my($t,$c,@p) = (0,1,sort {$a<=>$b} @{$_[0]});
  my @q = sort {$a<=>$b} @{$_[1]};
  my $f = $p[0]+$q[0];
  $t+= ($p[$_]+$q[$_]-$f)*$c*(@p-$c), $c++, $f=$p[$_]+$q[$_] for 1..$#p;
  $t
}

printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

