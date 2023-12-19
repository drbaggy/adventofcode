#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);

my($t0,$t1,$t2)=(time,0,0);

my%C;

while(<>){
  my( $x, @c ) = m{^(\S+?) (\S+)} ? ($1,split/,/,$2) : (next);      ## Parse string
  $t1+=test( $x               =~ /^\.*(.*?)\.*$/, @c );             ## Part 1
  $t2+=test( "$x?$x?$x?$x?$x" =~ /^\.*(.*?)\.*$/, @c,@c,@c,@c,@c ); ## Part 2
}

sub test {
  my( $v, $k, $x, $z, @c) = ( 0, "@_", @_ );
  return $C{$k}                  if      exists $C{$k}; ## Is is cached?
  return $C{$k} = !$x || $x!~/#/ unless defined $z;     ## Run out of blocks - true unless still have #
  return $C{$k} = 0              unless         $x;     ## No string but parts to find
      ## Count no of '?'s we can start with, and compute regex to match
  my $r = "^[?#]{$z}([.?][.]*(.*)|)\$";
      ## For each ?(0..n) we try to see if string starting with ? works
  $x =~ /$r/ && ( $v   += test( $2//'', @c ) ), substr $x,0,1,''
    for 1 .. $x =~ /^([?]+)/ && length $1;
  $C{$k} = $v + (                              ## Finally cache & return.
      $x =~ m{$r}       ? test( $2//'', @c )   ## See if one starting with "#" works
    : $x =~ s{^[.]+}{} && test( $x, $z, @c ) ) ## Strip trailing "." and try again
}

printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

