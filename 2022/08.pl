use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
my $time = time;

my $t = my $n = 0;

## Do stuff here...
my @g;
open my $fh, '<', 'data/08.txt';
while(<$fh>){
  chomp;
  push @g,[ split // ];
}

my $h = @g       -1;
my $w = @{$g[0]} -1;

for my $y (   0 .. $h ) {
  for my $x ( 0 .. $w ) {
    my ( $m, $f, @s )=( $g[$y][$x], 0, 0, 0, 0, 0 );
    $s[0]++, ($g[$_][$x] >= $m) && ($f|=1) && last for reverse    0 .. $y-1;
    $s[1]++, ($g[$_][$x] >= $m) && ($f|=2) && last for         $y+1 .. $h;
    $s[2]++, ($g[$y][$_] >= $m) && ($f|=4) && last for reverse    0 .. $x-1;
    $s[3]++, ($g[$y][$_] >= $m) && ($f|=8) && last for         $x+1 .. $w;
    my $p = $s[0] * $s[1] * $s[2] * $s[3];
    $n = $p if     $n <  $p;
    $t++    unless $f == 15;
  }
}

say "\nTime :", sprintf '%0.6f', time-$time;
say"$t\n$n";
