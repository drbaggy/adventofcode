#!/usr/bin/perl
use strict;
use warnings;
use feature qw(say);

## This time we keep a sliding window
## Note we only have to compare the next
## value with the one 3 previous all
## the way through.

my($c,@T)=0;
$_=<>,push@T,$_ for 0..2;
($_>shift@T)&&($c++),push@T,$_ while <>;
say $c;

