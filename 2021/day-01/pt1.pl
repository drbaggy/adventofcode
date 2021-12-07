#!/usr/bin/perl
use strict;
use feature qw(say);

my ($c,$t) = -1;
do { (($_=<>)>$t) && ($c++), $t=$_ } until eof;

say $c;
