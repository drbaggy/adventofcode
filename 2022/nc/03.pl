my $c = my $T = my $N = 0;
my %P = map { $_ => ++$c } 'a'..'z','A'..'Z';
open my $fh, '<', 'data/03.txt';
my @in = <$fh>;
close $fh;
for (@in) {
  my $x = $_;
  my %t = map { $_ => 1 } split //, substr $x,0, 0.5 * length $x,'';
  exists $t{$_} && ($T+=$P{$_},last) for split //,$x;
}
while(my(@l,%C) = splice @in,0,3) {
  //,map{$C{$_}|=1<<$'}grep{/\w/}split//,$l[$'] for 0..2;
  ($C{$_}==7) && ($N+=$P{$_},last)for keys %C;
}
say "$T\t$N";
