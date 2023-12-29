#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
#use Data::Dumper qw(Dumper);

my($t0,$t1,$t2)=(time,0,0);

my $i =0;
my @h = map {
  my @t = m{(-?\d+)}g;
  my $B = $t[4]/$t[3];
  my $A = $t[1] - $B * $t[0];
  #[ [ @t[0..2] ], [ @t[3..5] ], [ $A, $B ], $i++ ];
  { 'pos' => [@t[0..2]], 'vel' => [@t[3..5]], 'slope' => [ $A, $B ], 'idx' => $i++ }
} <>;

## Part 1 - the easy bit...
my($mn,$mx,$t) = @h < 20 ? (7,27) : (200000000000000,400000000000000);
$t=$_, $t1 += grep { ix( $h[$t-1], $_, $mn, $mx ) } @h[$t..$#h] for 1..$#h;

sub ix {
  my( $p, $q, $mn, $mx ) = @_;
  return 0 if $q->{'slope'}[1] == $p->{'slope'}[1];
  my $x = ( $q->{'slope'}[0] - $p->{'slope'}[0] ) / ( $p->{'slope'}[1] - $q->{'slope'}[1] );
  return 0 if ($x - $p->{'pos'}[0])/$p->{'vel'}[0] < 0
           || ($x - $q->{'pos'}[0])/$q->{'vel'}[0] < 0;
  my $y = $p->{'slope'}[0] + $p->{'slope'}[1] * $x;
  return 0 unless defined $mn;
  return 0 if $x<$mn || $x>$mx || $y<$mn || $y>$mx;
  [$x,$p];
}


my $N=300;
my @r = ( 0, map { $_, -$_ } 1..$N );

my $sc;
my($x,$y,$z);
O: for my $x ( @r ) {
 for my $y ( @r ) {
  my @I = ( I($h[1],$h[0],$x,$y),
            I($h[2],$h[0],$x,$y),
            I($h[3],$h[0],$x,$y) );
  next if !$I[0][0] || $I[0][1]!=$I[1][1] || $I[0][2]!=$I[1][2]
                    || $I[1][1]!=$I[2][1] || $I[1][2]!=$I[2][2];

   for my $z ( @r ) {
    my @IZ = (
      $h[1]{'pos'}[2] + $I[0][3] * ( $h[1]{'vel'}[2]+$z ),
      $h[2]{'pos'}[2] + $I[1][3] * ( $h[2]{'vel'}[2]+$z ),
      $h[3]{'pos'}[2] + $I[2][3] * ( $h[3]{'vel'}[2]+$z ),
    );
    next if $IZ[0] != $IZ[1] || $IZ[1] != $IZ[2];
    $t2 = $I[0][1]+$I[0][2]+$IZ[0];
    last O;
  }
}}

sub I {
  my( $one, $two, $x, $y ) = @_;
  my $a = { 'pos' => [ $one->{'pos'}[0],    $one->{'pos'}[1] ],
            'vel' => [ $one->{'vel'}[0]+$x, $one->{'vel'}[1]+$y ]};
  my $c = { 'pos' => [ $two->{'pos'}[0],    $two->{'pos'}[1] ],
            'vel' => [ $two->{'vel'}[0]+$x, $two->{'vel'}[1]+$y ]};
  my $d = - $a->{'vel'}[0] * $c->{'vel'}[1]
          + $a->{'vel'}[1] * $c->{'vel'}[0];
  return unless $d;
  my $qx = $c->{'vel'}[1]*($a->{'pos'}[0]-$c->{'pos'}[0])
         - $c->{'vel'}[0]*($a->{'pos'}[1]-$c->{'pos'}[1]);
  my $qy = $a->{'vel'}[0]*($c->{'pos'}[1]-$a->{'pos'}[1])
         - $a->{'vel'}[1]*($c->{'pos'}[0]-$a->{'pos'}[0]);
  my $t = $qx/$d;
  my $s = $qy/$d;
  return [ 1, $a->{'pos'}[0] + $qx/$d * $a->{'vel'}[0],
              $a->{'pos'}[1] + $qx/$d * $a->{'vel'}[1],
              $qx/$d ];
}
printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

__END__

## Part 1 - the easy bit...
my($mn,$mx,$t) = @h < 20 ? (7,27) : (200000000000000,400000000000000);
$t=$_, $t1 += grep { ix( $h[$t-1], $_, $mn, $mx ) } @h[$t..$#h] for 1..$#h;


for my $x in ( 1..30 ) {
  for my $y in ( 1..30 ) {
    my($i1,$i2,$i3) = ( ixo($h[1],$h[0],$x,$y),
                        ixo($h[2],$h[0],$x,$y),
                        ixo($h[2],$h[0],$x,$y) );
  }

sub ixo {
  my( $p, $q, $ox, $oy ) = @_;
  my ($ax, $cx, $ay, $cy ) =
    ($p->[1][0]+$ox, $q->[1][0]+$ox, $p->[1][1]+$oy, $q->[1][1]+$oy);
  return 0 unless $:q

  my $x = ( $q->[2][0] +$ox -$oy - $p->[2][0] ) / ( $p->[2][1]  +$oy - $q->[2][1] -$ox );
  my $d = (
  my $qx = - ($q[0][0] - $p[0][0])*($q->[1][1]+$oy)
           + ($q[1][0]+$ox)*($q[0][1]-$p[0][1]);
  my $qy = ($ox+$p[1][0])*($q[0][1]-$p[0][1]) - ($oy+$p[1][1]) * ($q[0][0]-$p[0][0]);
  my($t,$s)=($qx/$d,$qy/$d);
  return 0 if ($x - $p->[0][0])/$p->[1][0] < 0
           || ($x - $q->[0][0])/$q->[1][0] < 0;
  my $y = $p->[2][0] + $p->[2][1] * $x;
  return 0 unless defined $mn;
  return 0,
    if $x<$mn || $x>$mx || $y<$mn || $y>$mx;
  [$x,$p];
}


sub ix {
  my( $p, $q, $mn, $mx ) = @_;
  return 0 if $q->[2][1] == $p->[2][1];
  my $x = ( $q->[2][0] - $p->[2][0] ) / ( $p->[2][1] - $q->[2][1] );
  return 0 if ($x - $p->[0][0])/$p->[1][0] < 0
           || ($x - $q->[0][0])/$q->[1][0] < 0;
  my $y = $p->[2][0] + $p->[2][1] * $x;
  return 0 unless defined $mn;
  return 0,
    if $x<$mn || $x>$mx || $y<$mn || $y>$mx;
  [$x,$p];
}

