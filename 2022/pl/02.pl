use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
my $time = time;

## We could do some splitting and nice function to work out
## the score for each line, but we don't need to - we can
## simply use a look up as we only have 9 combinations and
## each combination gives one score.

## %st is the scores for part 1 (and we use $t as the total)
## %sn is the scores for part 2 (and we use $n as the total)

my($t,%st)=qw(0 AX 4 AY 8 AZ 3 BX 1 BY 5 BZ 9 CX 7 CY 2 CZ 6);
my($n,%sn)=qw(0 AX 3 AY 4 AZ 8 BX 1 BY 5 BZ 9 CX 2 CY 6 CZ 7);

## Loop through the file, keeping a running total for both
## part 1 & part 2, (in $t & $n respectively)

my$fn=__FILE__=~s/[^\/]*$//r.'../data/02.txt';1while($fn=~s/[^\/]*\/\.\.\///);
open my $fh, '<', $fn;
s/\s//g,$t+=$st{$_}, $n+=$sn{$_} while <$fh>;
close $fh;

## Output the two scores:

say "Time :", sprintf '%0.6f', time-$time;
say"$t\n$n";
