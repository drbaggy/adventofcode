my($n,$t)=(0,1);
my @l = map { /\S/ ? eval $_ : ()  } <>;
for(my $k=0;$k<@l;) {
  $n += (compare( @l[$k++,$k++] )>0)*$k;
}
unshift @l,[[2]],[[6]];
my @r = sort { compare( @l[$b,$a] ) } 0..$#l;
$r[$_] < 2 && ( $t *= ($_+1) )    for 0..$#l;

say $n/2;
say $t;

sub compare {
  my( $p1, $p2 ) = @_;
  for my $c ( 0 .. @{$p1}-1 ) {
    return -1 if $c >= @{$p2};
    my $t = ref $p1->[$c] || ref $p2->[$c]
    ? compare( map { ref $_->[$c] ? $_->[$c] : [$_->[$c]] } $p1, $p2 )
    : $p2->[$c] <=> $p1->[$c];
    return $t if $t;
  }
  @{$p1} < @{$p2}
}
