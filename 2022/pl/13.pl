use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
use Data::Dumper qw(Dumper);
my $time = time;

my$fn=__FILE__=~s/[^\/]*$//r.'../data/13.txt';1while($fn=~s/[^\/]*\/\.\.\///);

my($n,$t)=(0,1);
open my $fh,'<',$fn;
my @l = map { /\S/ ? parse( $_ ) : ()  } <$fh>;

## Part 1...
for(my $k=0;$k<@l;) {
  $n += (compare( @l[$k++,$k++] )>0)*$k;
}

## Part 2...
unshift @l,[[2]],[[6]];
my @r = sort { compare( @l[$b,$a] ) }     0..$#l;
$r[$_] < 2 && ( $t *= ($_+1) )        for 0..$#l;

say "Time :", sprintf '%0.6f', time-$time;
say $n/2;
say $t;

sub compare {
  my( $p1, $p2 ) = @_;
  for my $c ( 0 .. @{$p1}-1 ) {
    ## If the pointer is outside the length of p2 we know that p2 < p1
    ## so return -1
    return -1 if $c >= @{$p2};
    ## If at least one is a pointer - compare the two lists
    ## {promoting all non-lists to lists}
    ## otherwise compare the numbers...
    ## Return if they are not the same....
    my $t = ref $p1->[$c] || ref $p2->[$c]
          ? compare( map { ref $_->[$c] ? $_->[$c] : [$_->[$c]] } $p1, $p2 )
          : $p2->[$c] <=> $p1->[$c];
    return $t if $t;
  }
  ## Got to the end p1 < p2 if the length of p1 is less
  ## than length of p2 - or they are the same if the
  ## length is the same...
  return @{$p1} < @{$p2}
}

## Don't need this - can you "eval" but I leave it here!
sub parse {
  my @i = [];
  $_   eq '[' ?  ( push( @{$i[-1]}, [] ) && push @i,$i[-1][-1] )
  : $_ eq ']' ?  pop @i
  : $_ eq ',' || ( push @{$i[-1]}, $_ ) for $_[0] =~ m{(\[|\]|\d+|,)}g;
  $i[0]
}
