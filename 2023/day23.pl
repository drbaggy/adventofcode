#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
#use Data::Dumper qw(Dumper);

my($t0,$t1,$t2)=(time,0,0);

my @LM = (0..9,'A'..'Z');
my @map = map { chomp; [ split //, $_ ] } <>;
my $H = @map; my $W = @{$map[0]};
my $S = length( ( join '', @{$map[0]} ) =~ s{[.].*}{}sr );
my @nodes = ([0,$S,0,0,0]);
my @D = ( [-1,0],[0,1],[1,0],[0,-1] );
my $c=1;
$map[0][$S]='S';
$map[-1][-2]='E';

for my $R ( 1..$H-2 ) {
  for my $C ( 1..$W-2 ) {
    next if $map[$R][$C] eq '#';
    my $n=0;
    ($map[ $R+$_->[0] ][ $C+$_->[1] ] eq '#')||($n++)  for @D;
    next unless $n>2;
           ## row, $col, $index, dag distance, graph distance
    push @nodes, [ $R, $C, $c, 0, 0 ];
    $c++;
    $map[$R][$C]='X';
  }
}

push @nodes,( [$H-1,$W-2,$c,0,0]);

my @FOR = ( {qw(T 0 ] 1 _ 1 [ 1 ^ 0 > 1 v 1 < 1)},
            {qw(T 1 ] 0 _ 1 [ 1 ^ 1 > 1 v 1 < 1)},
            {qw(T 1 ] 1 _ 0 [ 1 ^ 1 > 1 v 0 < 1)},
            {qw(T 1 ] 1 _ 1 [ 0 ^ 1 > 1 v 1 < 1)} );

my %STOP = (' ',qw(1 S 1 ),'#',qw(1 [ 1 ] 1 T 1 _ 1));
my @F= map { 2**$_ } 0..50;

#say @{$_} for @map;

## Compact chart & find links - both as a DAG

my @dag       = map { {} } @nodes;
my @links     = map { {} } @nodes;
for my $start (@nodes) {
  for my $i (0..3) {
    my $r = $start->[0]; my $c = $start->[1];
    if( ($r+$D[$i][0])>=0 && ($r+$D[$i][0])< $H &&
        $map[$r+$D[$i][0]][$c+$D[$i][1]] ne '#' ) {
      my $seq = '';
      my $forward = 0;
      O: while(1) {
        $forward ||= $FOR[$i]{$map[$r][$c]}||0;
        $r+=$D[$i][0], $c += $D[$i][1];
        last if $map[$r][$c]eq'X'||$map[$r][$c]eq'S'||$map[$r][$c]eq'E';
        $seq .= $map[$r][$c];
        $map[$r][$c]=~tr/.<>^v/ []^_/;
        for(0..3) {
          next if abs($i-$_) == 2;
          next if $map[$r+$D[$_][0]][$c+$D[$_][1]] eq '#';
          $i = $_; next O;
        }
        last;
      }
      my $to = -1;
      ($_->[0]==$r && $_->[1]==$c) && ($to = $_->[2]) for @nodes;
      $dag[   $start->[2]]{$to} = 1+length $seq unless $forward;
      $links[ $start->[2]]{$to} = 1+length $seq;
    }
  }
}

#print Dumper(\@links);exit;

my @q = (0);
while(@q) {
  my $q = pop @q;
  for(keys %{$dag[$q]}) {
    if( $nodes[$_][3] < $nodes[$q][3] + $dag[$q]{$_} ) {
      $nodes[$_][3] = $nodes[$q][3] + $dag[$q]{$_};
      push @q,$_;
    }
  }
}

#my($n1,$l1) = %{$links[0]};
#my($n2,$l2) = %{$links[-1]};
#@q=([$n1,$l1+$l2,1]); # Start at node 0, length is 0, visited = 1 (0th bit set)
@q=([0,0,1,0]);

my %seen;
while( @q ) {
  my($n,$l,$nh,$sq) = @{pop @q};
  #printf "xx %3d %3d %10d %s\n", $n,$l,$nhr;
  if( exists $seen{$nh} ) {
    if( $seen{$nh} > $l ) {
      next;
    }
  }
  next if exists $seen{$nh} && $seen{$nh} > $l; ## Already seen higher value for "node set"
  $seen{$nh} = $l;
  if($l > $nodes[$n][4]) {
    $nodes[$n][4] = $l;
#    say $n, ' ',$l,' ',$sq if $n == $#nodes;
  }
#  next if $n==$n2;
#  next if $n==$#nodes;
  for( sort keys %{$links[$n]} ) {
    push @q, [ $_, $l + $links[$n]{$_}, $nh | $F[$_], $sq.'-'.$_ ]  unless $nh & $F[$_];
  }
}

#print Dumper(\@nodes);
$t1 = $nodes[-1][3];
$t2 = $nodes[-1][4];
printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

