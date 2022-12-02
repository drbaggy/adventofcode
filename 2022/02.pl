use strict;
use warnings;
use feature qw(say);
use Data::Dumper qw(Dumper);
use Carp qw(croak);

# We could do some splitting and nice function
# But we know the score for each line.
# %st is the scores for part 1 (and we use $t as the total)
# %sn is the scores for part 2 (and we use $n as the total)

my($t,%st)=(0,'A X'=>4,'A Y'=>8,'A Z'=>3,'B X'=>1,'B Y'=>5,'B Z'=>9,'C X'=>7,'C Y'=>2,'C Z'=>6);
my($n,%sn)=(0,'A X'=>3,'A Y'=>4,'A Z'=>8,'B X'=>1,'B Y'=>5,'B Z'=>9,'C X'=>2,'C Y'=>6,'C Z'=>7);

open my $fh, '<', 'data/02.txt' or croak 'No data';
chomp,$t+=$st{$_},$n+=$sn{$_} while <$fh>;
close $fh;

say"$t\n$n"

