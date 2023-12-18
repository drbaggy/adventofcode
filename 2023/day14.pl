#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
use Data::Dumper qw(Dumper);

my($t0,$t1,$t2)=(time,0,0);

## We wrap the map in "X"s as it avoids the issues of falling of the end...
my @map = map { chomp; $_='X'.$_.'X'; [split //] } <>;
my $rows = @map;
my $cols = @{$map[0]} - 2;
my( $TM, %CH, @SC ) = ( 1_000_000_000 );

unshift @map,[ ('X') x (2+$cols) ];
push    @map,[ ('X') x (2+$cols) ];

for(0..999_999_999) {
## Tip N
  for my $r (1..$rows) {         for ( grep { $map[$r][$_] eq 'O' } 1..$cols ) {
    my $j = $r; $j-- while( $map[$j-1][$_]  eq  '.');
    $j==$r || (( $map[$r][$_],$map[$j][$_])=('.','O'));
  } }
## First time round store result for part 1
  unless($t1) { for my $c (1..$cols) {
    $t1+=$rows+1-$_              for   grep { $map[$_][$c] eq 'O' } 1..$rows;
  } }
## Tip W
  for my $c (1..$cols) {         for ( grep { $map[$_][$c] eq 'O' } 1..$rows ) {
    my $j = $c; $j-- while( $map[$_][$j-1]  eq  '.');
    $j==$c || (( $map[$_][$c],$map[$_][$j])=('.','O'));
  } }
## Tip S
  for my $r (reverse 1..$rows) { for ( grep { $map[$r][$_] eq 'O' } 1..$cols ) {
    my $j = $r; $j++ while( $map[$j+1][$_]  eq  '.');
    $j==$r || (( $map[$r][$_], $map[$j][$_] ) = ('.','O'));
  } }
## Tip E
  for my $c (reverse 1..$cols) { for ( grep { $map[$_][$c] eq 'O' } 1..$rows ) {
    my $j = $c; $j++ while( $map[$_][$j+1]  eq  '.');
    $j==$c || (( $map[$_][$c],$map[$_][$j])=('.','O'));
  } }
## Check for hit - if work out value for 1e9 entry...
## o/w cache...
  my $K = join '', map{@$_} @map;
  $t2 = $SC[ $CH{$K} + ( $TM - 1 - $_ ) % ( $_-$CH{$K} ) ], last if exists $CH{$K};
  $CH{$K}=$_;
  my $score = 0;
  for my $c (1..$cols) {
    $score+=$rows+1-$_           for   grep { $map[$_][$c] eq 'O' } 1..$rows;
  }
  push @SC,$score;
}


printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

