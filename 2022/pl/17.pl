use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time sleep);
use Data::Dumper qw(Dumper);

my $time = time;

my $fn=__FILE__=~s/[^\/]*$//r.'../data/17.txt';1while($fn=~s/[^\/]*\/\.\.\///);
open my $fh, '<', $fn;
my @in = map { $_ eq '>' ? 1 : -1 } grep {/[<>]/}split //, <$fh>;
close $fh;

my($bs,$bl,$rn,@r,@b,@h) = (511,257,0,map{my$q=$_;[map{my$p=$_;[map{$_>>$p}@{$q}]}-4..3]}
[15],[4,14,4],[2,2,14],[8,8,8,8],[12,12]);
my @t=$bs;

while( 1 ) {
  my($x,$y,$r) =( 2, 0, $r[$rn++%5] );
  pop @t while $t[-1] == $bl;
  push @h, @t-1;
  if($t[-1] == $bs) { push @b, [ $rn, scalar @t ]; last if @b==3; }
  my $count = @{$r->[0]}-1;
  push @t, $bl for -$count .. 3;
  while(++$y) {
    push @in, my $d = shift @in;
    $x+=$d unless grep { $t[-$y-$_] & $r->[$x+$d][$_] } 0 .. $count;
    map( { $t[-$y-$_] |= $r->[$x][$_] } 0..$count ), last if
      grep { $t[-$y-$_-1] & $r->[$x][$_] } 0 .. $count;
  }
}

my($d,@res) = $b[2][0]-$b[1][0];
for( 2_022, 1_000_000_000_000 ) {
  my($i,$m)=($_%$d,int($_/$d));
  ($i+=$d,$m--) if $i<$b[1][0];
  push @res, $h[$i] + $m*($b[2][1]-$b[1][1]);
}

say "Time :", sprintf '%0.6f', time-$time;
say for @res;

