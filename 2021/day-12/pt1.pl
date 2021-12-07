#!/usr/bin/perl

use strict;
use warnings;
use feature qw(say);
use Data::Dumper qw(Dumper);

my $c = 0;
my $t = <>;
while(<>) {
  $c++ if $_ > $t;
  $t=$_;
}

say $c;
