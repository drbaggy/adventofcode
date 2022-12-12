use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
my $time = time;

my @p1 = (['']);
my @p2 = (['']);
my$fn=__FILE__=~s/[^\/]*$//r.'../data/05.txt';1while($fn=~s/[^\/]*\/\.\.\///);
open my $fh, '<', $fn;

## We loop through teh first set of rows {those with [letter]
## stacks} in them finding the letters and putting them on the
## individual "queues" We do this until a line doesn't contain a [
##
## We keep to set stacks - one for part 1 and one for part 2
##
## Because it is easier we number the stacks with "0" at the top....

while(my $row=<$fh>) {
  last unless $row=~m{\[};
  my $p = 0;
  ++$p, m{\w} && ( push @{$p1[$p]}, $& ) && push @{$p2[$p]}, $&
    while $_=substr $row,0,4,'';
}

## Now we loop through the rest of the file, following the
## instructions. We use splice to remove elements from the top of
## each stack, and replacing them at the top of the other stack.

## This is where part 2 is actually easier. In part 1 the crates are
## moved one at a time so we have to reverse the stack that we splce
## off before pushing back onto the new stack. Whereas in part 2 we
## don't have to do this.

m{(\d+).*(\d+).*(\d+)}
&& ( unshift @{$p1[$3]}, reverse splice @{$p1[$2]},0,$1 )
&& ( unshift @{$p2[$3]},         splice @{$p2[$2]},0,$1 ) while <$fh>;
close $fh;

say "Time :", sprintf '%0.6f', time-$time;
say join'',map{$_->[0]}@{$_}for\@p1,\@p2;
