use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
my $time = time;

## Initialize the ptr, x-register, The horizonal positon of the CRT,
## The total for part 1 and the string for part 2
my($p,$x,$z,$t,$n)=(1,1,0,0,'');

## Open programme and execute each line.
## The addx command is a noop + a single time unit add command
## So we execute our noop function ("o") for both operations
## The if it is an add operation we run it again, and actually
## do the add to the register

my$fn=__FILE__=~s/[^\/]*$//r.'../data/10.txt';1while($fn=~s/[^\/]*\/\.\.\///);
open my $fh, q(<), $fn;
o(),/addx (\S+)/&&(o(),$x+=$1) while <$fh>;
close $fh;

## Our "noop" method
## First check to see if it is one of the 20th, 60th, ....
##   if so update the total for part 1 - being position * X
## Second update our string for part 2
##   abs($z-$x) works out whether we are overlapping the
##      sprite
##   add a "\n" if we are at the start of the line...
## We then increment both pointers, and wrap z if requird.
sub o {
  $t += $p*$x if $z == 19;
  $n .= ($z?'':"\n").(abs($z-$x)<2?'#':'.');
  $p ++;
  $z ++;
  $z %=40;
}

say "Time :", sprintf '%0.6f', time-$time;
say"$t$n";
