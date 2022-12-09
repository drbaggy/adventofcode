use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
my $time = time;

## `@e` is the list of calories carried by each elf.

my @e=(0);

## We loop through the file - if the line is blank
## we add another elf to the list and initialize
## the calories as 0 o/w we add the calories to the
## last elf in the list.

## We use the ternary operator to create an
## `if`/`else` command within the postfix `while`
## a trick to make perl code even more compact.

open my $fh, '<', 'data/01.txt';
/\d/ ? ($e[-1]+=$_) : push @e,0 while <$fh>;
close $fh;

## We use a IIFE, that takes the output of a numeric
## sort (of the elves) to compute the highest total
## for an elf AND the highest total for the top
## three elves.

say "Time :", sprintf '%0.6f', time-$time;
say for sub { $_[0], $_[0]+$_[1]+$_[2] }->(sort {$b<=>$a} @e);

## IIFE - *I*mmediately *I*nvoked *F*unction *E*xpression

## Is a function (in this case as closure) which is
## executed immediately that it is defined. This is
## common practice in Javascript to pass in an external
## library *OR* alias an object or method to make
## the internal code shorter/easier to read.

