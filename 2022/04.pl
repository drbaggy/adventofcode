use strict;
use warnings;
use feature qw(say);

my($t,$n);

## We read each line of the file in and pass it through the regex
## which splits it into the four end points..

## For part 1 we need to see if one set of inputs is within the
## range of the 2nd. So if gp 2 is inside gp 1:
##   $1 <= $3        &&   $4 <= $2
## and we can then flip 1/3 & 2/4 to give
##   $3 <= $1        &&   $2 <= $4
## We use the "&&" trick to replace an `if` to update $t if this is
## true.

## Part 2 is actually easier - and after 8 yrs of e! we know that
## if the end of region 1 is less than the start of region 2 or
## v/v - then they do not overlap...
## Here we use the "||" trick to replace an `unless` to update
## $n if this is false

open my $fh, '<', 'data/04.txt';
m{ (\d+) - (\d+) , (\d+) - (\d+) }x,
  ( $1<=$3 && $4<=$2 || $3<=$1 && $2<=$4 ) && $t++,
    $4<$1            || $2<$3              || $n++ while <$fh>;
close $fh;

## Output the two scores:

say"$t\n$n"

