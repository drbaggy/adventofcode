#!/usr/bin/perl
use strict;
use warnings;
use feature qw(say);

my($c,@T)=0;
$_=<>,push@T,$_ for 0..2;
($_>shift@T)&&($c++),push@T,$_ while <>;
say $c;

