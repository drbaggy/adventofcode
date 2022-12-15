use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
my $time = time;

## Open programme and execute each line.
## The addx command is a noop + a single time unit add command
## So we execute our noop function ("o") for both operations
## The if it is an add operation we run it again, and actually
## do the add to the register

my($h,@g,$x,$y,$X,$Y)=-1;
my$fn=__FILE__=~s/[^\/]*$//r.'../data/12.txt';1while($fn=~s/[^\/]*\/\.\.\///);
open my $fh,'<',$fn;
while(<$fh>) {
  chomp;
  $h++;
  /^(.*)E/ && (($y,$x)=($h,length$1));
  /^(.*)S/ && (($Y,$X)=($h,length$1));
  tr/ES/za/;
  push @g,[ map { ord($_)-95} split // ];
}
close $fh;
my($w,$n,$t,@q,@s,$l,$v)=( @{$g[0]}-1,0,0, [$x,$y,0] );

$s[$Y][$X]=0;

while(@q) {
  ($x,$y,$l) = @{ shift @q };
  next if $s[$y][$x]++;
  1 == ( $v = $g[$y][$x] - 1 ) && ($t||=$l);
  $x == $X && $y == $Y && ($n=$l);
  push @q, ( $x > 0  && $g[$y  ][$x-1] >= $v ) ? [$x-1, $y  , $l+1] : (),
           ( $x < $w && $g[$y  ][$x+1] >= $v ) ? [$x+1, $y  , $l+1] : (),
           ( $y > 0  && $g[$y-1][$x  ] >= $v ) ? [$x  , $y-1, $l+1] : (),
           ( $y < $h && $g[$y+1][$x  ] >= $v ) ? [$x  , $y+1, $l+1] : ();
}

say "Time :", sprintf '%0.6f', time-$time;
say "$n\n$t"

