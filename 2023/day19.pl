#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
#use Data::Dumper qw(Dumper);

my($t0,$t1,$t2)=(time,0,0);

my %wf; my @L =qw(x m a s);
while(<>) {
  if( /^(\w*)\{(.*)\}/ ) {
    my($key,@parts)=($1,split/,/,$2);
    $wf{$key} = [ map { /(\w)([<>])(\d+):(\w+)/
                    ? [ $4, $1, $2, $3 ] : [ $_, '', '', '' ]
                    } @parts ], next if $key;

    my($x,%P) = ('in',map { split /=/, $_ } @parts);
    while( 1 ) {
                                     last if $x eq 'R';
      map( { $t1+= $_ } values %P ), last if $x eq 'A';
      for( @{$wf{$x}} ) {
        $x = $_->[0], last if
             $_->[1] eq '' ||
           ( $_->[2] eq '<' ? $P{$_->[1]} < $_->[3]
                            : $P{$_->[1]} > $_->[3] );
      }
    }
    next;
  }
  my @b = ( { 'p' => 'in', map { $_ => [1,4000] } @L } );
  while( @b ) {
    my $x = shift @b;
    if( $x->{'p'} eq 'A' ) {
      my $v = 1; $v *= ($_->[1]-$_->[0]+1) for @{$x}{@L};
      $t2 += $v;
    } elsif( $x->{'p'} ne 'R' ) {
      for ( @{$wf{$x->{'p'}}} ) {
        my( $n, $k, $e, $v ) = @{$_};
        my $t = { 'p' => $n, map { $_ => [ $x->{$_}[0], $x->{$_}[1] ] } @L };
        if( $k eq '' ) {
          push @b, $t;
        } elsif( $e eq '<' ) { ## split below
          if( $x->{$k}[1] < $v ) {     ## we map all of the region;
            push @b, $t;
          } elsif( $x->{ $k }[0] < $v ) {
            $x->{ $k }[0] = $v; $t->{ $k }[1] = $v-1; push @b, $t;
          }
        } else { ## split above
          if( $x->{$k}[0] > $v ) {     ## we map all of the region;
            push @b, $t;
          } elsif( $x->{ $k }[1] > $v ) {
            $x->{ $k }[1] = $v; $t->{ $k }[0] = $v+1; push @b, $t;
          }
        }
      }
    }
  }
}
## Convert map into numeric array of weights..., get dimensions
printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

