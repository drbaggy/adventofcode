use strict; use warnings;
use feature qw(say);
use Time::HiRes qw(time);
my $time = time;

## We slurp the string in from the file.

open my $fh, q(<), 'data/06.txt' or die "No input";
my $input = <$fh>;
close $fh;

## We now look for solutions for markers of length 4 and 14.

say find_marker($input, $_) for 4,14;

## find_marker takes two inputs the string, and the size of
## markers

## We split the string into, the first "n" characters
## ($block) and the rest of the string ($str). Finally
## we set up $n to represent the number of characters
## processed - at the moment $n.

## We then loop through the remaining string.
## The block contains a duplicate letter, we incrememnt
## the position ($n) by one, and remove the first letter
## from $block, and the first letter from $str to the
## end. If there isn't a match we have found the mark
## and return

sub find_marker {
  my $block = substr my $str = $_[0], 0, my $n = $_[1], '';
  $block =~ /(.).*\1/ ? ( $n++, $block = substr( $block, 1 ) . substr $str, 0, 1, '' )
                      : return $n      while $str;
  -1;
}
