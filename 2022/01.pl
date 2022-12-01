use strict;
use warnings;
use feature qw(say);
use Data::Dumper qw(Dumper);
use Carp qw(croak);

open my $fh, '<', 'data/01.txt' or croak 'No data';
my @elves=(0);
/\d/mxs?($elves[-1]+=$_):push@elves,0 while<$fh>;
close $fh;

say for sub { $_[-1], $_[-1]+$_[-2]+$_[-3] }->(sort {$a<=>$b} @elves);
