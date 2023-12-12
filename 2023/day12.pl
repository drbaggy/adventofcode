#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);

my($t0,$t1,$t2)=(time,0,0);

my%C;

while(<>){
  my( $s, @c ) = m{^(\S+?) (\S+)} ? ($1,split/,/,$2) : (next);      ## Parse string
  $t1+=test( $s               =~ /^\.*(.*?)\.*$/, @c );             ## Part 1
  $t2+=test( "$s?$s?$s?$s?$s" =~ /^\.*(.*?)\.*$/, @c,@c,@c,@c,@c ); ## Part 2
}

sub test {
  my( $v, $k, $s, $z, @c) = ( 0, "@_", @_ );
  return $C{$k}                  if      exists $C{$k}; ## Is is cached?
  return $C{$k} = !$s || $s!~/#/ unless defined $z;     ## Run out of blocks - true unless still have #
  return $C{$k} = 0              unless         $s;     ## No string but parts to find
      ## Count no of '?'s we can start with, and compute regex to match
  my $r = "^[?#]{$z}([.?][.]*(.*)|)\$";
      ## For each ?(0..n) we try to see if string starting with ? works
  $s =~ /$r/ && ( $v   += test( $2//'', @c ) ), substr $s,0,1,''
    for 1 .. $s =~ /^([?]+)/ && length $1;
  $C{$k} = $v + (                              ## Finally cache & return.
      $s =~ m{$r}       ? test( $2//'', @c )   ## See if one starting with "#" works
    : $s =~ s{^[.]+}{} && test( $s, $z, @c ) ) ## Strip trailing "." and try again
}

printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

