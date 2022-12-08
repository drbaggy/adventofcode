use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
use Data::Dumper qw(Dumper);
my $time = time;

my $t = my $n = 0;

## Do stuff here...
my @grid;
open my $fh, '<', 'data/08.txt';
while(<$fh>){
  chomp;
  push @grid,[ split // ];
}

my $h = @grid       -1;
my $w = @{$grid[0]} -1;

for my $y (   0 .. $h ) {
  for my $x ( 0 .. $w ) {
    my ( $my_h, $f, @see )=( $grid[$y][$x], 0, 0, 0, 0, 0 );

    ($grid[$_][$x] >= $my_h) && ($f|=1) for    0 .. $y-1;
    ($grid[$_][$x] >= $my_h) && ($f|=2) for $y+1 .. $h;
    ($grid[$y][$_] >= $my_h) && ($f|=4) for    0 .. $x-1;
    ($grid[$y][$_] >= $my_h) && ($f|=8) for $x+1 .. $w;
    $t++ unless $f == 15;

    $see[0]++, ($grid[$_][$x] >= $my_h) && last for reverse    0 .. $y-1;
    $see[1]++, ($grid[$_][$x] >= $my_h) && last for         $y+1 .. $h;
    $see[2]++, ($grid[$y][$_] >= $my_h) && last for reverse    0 .. $x-1;
    $see[3]++, ($grid[$y][$_] >= $my_h) && last for         $x+1 .. $w;
    my $sc= $see[0]*$see[1]*$see[2]*$see[3];

    $n = $sc if $sc > $n;
  }
}

say "\nTime :", sprintf '%0.6f', time-$time;
say"$t\n$n";
