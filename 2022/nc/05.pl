my @p1 = (['']);
my @p2 = (['']);
open my $fh, '<', 'data/05.txt';
while(my $row=<$fh>) {
  last unless $row=~m{\[};
  my $p = 0;
  ++$p, m{\w} && ( push @{$p1[$p]}, $& ) && push @{$p2[$p]}, $&
    while $_=substr $row, 0, 4, '';
}
m{move (\d+) from (\d+) to (\d+)} &&
  ( unshift @{$p1[$3]}, reverse splice @{$p1[$2]}, 0, $1 ) &&
  ( unshift @{$p2[$3]},         splice @{$p2[$2]}, 0, $1 ) while <$fh>;
close $fh;
say join '', map { $_->[0] } @p1;
say join '', map { $_->[0] } @p2;
