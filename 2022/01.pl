use strict;
use warnings;
use feature qw(say);

## Elves is the list of calories carried by each
## elf.

my @e=(0);

## We loop through the file - if the line is blank
## we add another elf to the list and initialize
## the calories as 0 o/w we add the calories to the
## last elf in the list.

open my $fh, '<', 'data/01.txt';
/\d/ ? ($e[-1]+=$_) : push@e,0 while<$fh>;
close $fh;

## We use a self executing closure to take the
## output of a numeric sort to compute the highest
## total for an elf AND the highest total for the
## top three elves.

say for sub { $_[0], $_[0]+$_[1]+$_[2] }->(sort {$b<=>$a} @e);
