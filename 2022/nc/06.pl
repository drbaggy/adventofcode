open my $fh, q(<), 'data/06.txt' or die "No input";
my $input = <$fh>;
close $fh;
my @t = map { find_marker($input, $_) } 4,14;
say for @t;
sub find_marker {
  my $block = substr my $str = $_[0], 0, my $n = $_[1], '';
  $block =~ /(.).*\1/ ? ( $n++, $block = substr( $block, 1 ) . substr $str, 0, 1, '' )
                      : return $n      while $str;
}
