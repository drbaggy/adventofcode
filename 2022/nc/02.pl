my($t,%st)=qw(0 AX 4 AY 8 AZ 3 BX 1 BY 5 BZ 9 CX 7 CY 2 CZ 6);
my($n,%sn)=qw(0 AX 3 AY 4 AZ 8 BX 1 BY 5 BZ 9 CX 2 CY 6 CZ 7);
s/\s//g,$t+=$st{$_}, $n+=$sn{$_} while <>;
say"$t\n$n"
