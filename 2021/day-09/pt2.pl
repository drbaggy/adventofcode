#!/usr/bin/perl

use strict;
use warnings;
use feature qw(say);
use Data::Dumper qw(Dumper);

my $c = 0;
my @d;
while(<>) {
  chomp;
  push @d, [9, (split //), 9];
}

push    @d, [ (9) x @{$d[0]} ];
unshift @d, [ (9) x @{$d[0]} ];

my @grid = map { [map { $_==9?'#':' ' } @{$_}] } @d;

my @symbols = ( 0..9, 'a'..'z', 'A'..'Z', qw(! @ $ £ % ^ & * ~ \ | / .),',' );

my @sizes;

foreach my $v ( 1 .. @d -2 ) {
  foreach my $h ( 1 .. @{$d[0]} - 2 ) {
    next if $d[$v][$h] == 9;
    next unless
       $d[$v][$h] < $d[$v+1][$h]
    && $d[$v][$h] < $d[$v-1][$h]
    && $d[$v][$h] < $d[$v][$h+1]
    && $d[$v][$h] < $d[$v][$h-1];
    push @sizes,flood($v,$h);
    push @symbols, shift @symbols;
  }
}

my @Z = sort { $a <=> $b } @sizes;

say join '', @{$_} for @grid;
say "@Z";

sub flood {
  my($v,$h) =@_;
  return 0 if $d[$v][$h]==9;
  my $x = 1 + ( $d[$v][$h]<$d[$v+1][$h] ? flood($v+1,$h) : 0 )
            + ( $d[$v][$h]<$d[$v-1][$h] ? flood($v-1,$h) : 0 )
            + ( $d[$v][$h]<$d[$v][$h+1] ? flood($v,$h+1) : 0 )
            + ( $d[$v][$h]<$d[$v][$h-1] ? flood($v,$h-1) : 0 );
  $d[$v][$h] = 9;
  $grid[$v][$h] = $symbols[0];
  return $x;
}
say $Z[-3]*$Z[-2]*$Z[-1];
