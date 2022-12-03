use strict;
use warnings;
use feature qw(say);

## Rather than using a function to get the
## priority of a letter we just put together
## a quick look-up..

my $c = my $T = 0;
my %P = map { $_ => ++$c } 'a'..'z','A'..'Z';

## We slurp the strings in an array - this is the
## easiest way to grab 3 lines at a time - using
## splice below

open my $fh, '<', 'data/03.txt';
my @in = <$fh>;
close $fh;

## Loop through array one line at time, split the
## string in two using the 4-param version of
## substr which replaces the 2nd half with nothing

## Use a hash to store each letter we see in the
## first, and loop through second string until we
## find a duplicate...

for (@in) {
  my $x = $_;
  my %t = map { $_ => 1 } split //, substr $x,0, 0.5 * length $x,'';
  exists $t{$_} && ($T+=$P{$_},last) for split //,$x;
}

## Output first score and reset

say $T;
$T = 0;

## For each triple - we create a hash for each letter
## which has the 1 bit set for line 1, 2 bit set for
## line 2 and 4 bit set for line 3..

## characters which have a "score" of 7 (all bits set)
## are in all three lines... so we had their priority
## and bomb out!

while(my(@l,%C) = splice @in,0,3) {
  //,map{$C{$_}|=1<<$'}grep{/\w/}split//,$l[$'] for 0..2;
  ($C{$_}==7) && ($T+=$P{$_},last)for keys %C;
}

## Output the second score

say $T;

