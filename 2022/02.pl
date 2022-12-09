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

my($t,%st)=(0,'A X'=>4,'A Y'=>8,'A Z'=>3,'B X'=>1,'B Y'=>5,'B Z'=>9,'C X'=>7,'C Y'=>2,'C Z'=>6);
my($n,%sn)=(0,'A X'=>3,'A Y'=>4,'A Z'=>8,'B X'=>1,'B Y'=>5,'B Z'=>9,'C X'=>2,'C Y'=>6,'C Z'=>7);

## Loop through the file, keeping a running total for both
## part 1 & part 2, (in $t & $n respectively)

open my $fh, '<', 'data/02.txt';
chomp, $t += $st{$_}, $n += $sn{$_} while <$fh>;
close $fh;

## Output the two scores:

say "Time :", sprintf '%0.6f', time-$time;
say"$t\n$n";
