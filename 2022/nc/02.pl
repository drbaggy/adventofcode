my($t,%st)=(0,'A X'=>4,'A Y'=>8,'A Z'=>3,'B X'=>1,'B Y'=>5,'B Z'=>9,'C X'=>7,'C Y'=>2,'C Z'=>6);
my($n,%sn)=(0,'A X'=>3,'A Y'=>4,'A Z'=>8,'B X'=>1,'B Y'=>5,'B Z'=>9,'C X'=>2,'C Y'=>6,'C Z'=>7);
open my $fh, '<', 'data/02.txt';
chomp, $t += $st{$_}, $n += $sn{$_} while <$fh>;
close $fh;
say"$t\n$n";
