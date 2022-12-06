use strict; use warnings;
use feature qw(say);
use Time::HiRes qw(time);
my $time = time;

open my $fh, q(<), 'data/06.txt' or die "No input";
my $input = <$fh>;
close $fh;
say find_marker($input, $_) for 4,14;
## Do stuff here...

sub find_marker {
  my $block = substr my $str = $_[0], 0, my $n = $_[1], '';
  $block =~ /(.).*\1/ ? ( $n++, $block = substr( $block, 1 ) . substr $str, 0, 1, '' )
                      : return $n      while $str;
  -1;
}
