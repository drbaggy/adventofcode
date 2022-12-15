use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
use Data::Dumper qw(Dumper);

my$fn=__FILE__=~s/[^\/]*$//r.'../data/14.txt';1while($fn=~s/[^\/]*\/\.\.\///);

my($n,$t,$y,$x,$z,@m)=(0,0);
my $time = time;

open my $fh,'<',$fn;
while(<$fh>) {
  my($s,@p) = map { [split/,/] } split / -> /;
  $m[$z=$s->[1]][$s=$s->[0]]='#';
  for(@p) {
    ($x,$y) = ( $_->[0] <=> $s, $_->[1] <=> $z );
    $m[ $z+=$y ][ $s+=$x ]='#' while $s != $_->[0] || $z != $_->[1] ;
  }
}
close $fh;

push @m, [], [ ('#') x (503+($z=$#m)) ];

until($m[$y=0][$x=500]) {
  while(1) {
    $n||=$t if (++$y)>$z;
    $m[$y][$x] && ( $m[$y][$x-1] ? $m[$y][$x+1] ? ($m[$y-1][$x]='o',$t++,last) : $x++ : $x-- );
  }
}
say "Time :", sprintf '%0.6f', time-$time;
say "$n\n$t";
