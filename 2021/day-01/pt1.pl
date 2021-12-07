#!/usr/bin/perl
use strict;
use feature qw(say);

## We need to keep track of those times where the
## following number is greater than the current one,
## We loop through the array, and if the next value
## is greater than the current one we increment the
## counter by 1 - we start with the counter as -1,
## because the first time through the loop we count
## 1 rather than 0...

my ($c,$t) = -1;
do { (($_=<>)>$t) && ($c++), $t=$_ } until eof;

say $c;
