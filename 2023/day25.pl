#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
#use Data::Dumper qw(Dumper);

my($t0,$t1,$t2)=(time,0,99);

my @H;my @L;my %V;my $c=0;
for (<>) {
  my($k,@t) = m{(\w+)}g;
  $V{$k}//=$c++;
  $V{$_}//=$c++ for @t;
  $H[$V{$k}]{$V{$_}}=1 for @t;
  $H[$V{$_}]{$V{$k}}=1 for @t;
  push @L,[$V{$k},$V{$_}] for @t;
}
## Find the links which cause longest distance between sides once cut. This
## would suggest lower connectivity...
my @N = sort { $b->[2] <=> $a->[2] } map { cut_and_count( @{$_} ) } @L;

## Cut those links and see if we get a split in two
for( @N[0..2] ) { delete $H[$_->[0]]{$_->[1]}; delete $H[$_->[1]]{$_->[0]}; }
my %d = ($N[0][0]=>0); my @q =($N[0][0]);
while(@q) {
  my $n = shift @q;
  $d{$_} = $d{$n} + 1, push @q,$_ for grep { !exists $d{$_} } keys %{$H[$n]};
}
for( @N[0..2] ) { $H[$_->[0]]{$_->[1]}=1; $H[$_->[1]]{$_->[0]}=1; }

$t1 = (scalar %d)*(@H - scalar %d);

printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

sub cut_and_count {
  my( $l, $r ) = @_;
  my %d = ($l=>0);
  my @q = ($l);
  delete $H[$l]{$r};
  delete $H[$r]{$l};
  O: while(@q) {
    my $n = shift @q;
    for(keys %{$H[$n]}) {
      next if exists $d{$_};
      $d{$_}=$d{$n}+1;
      last O if $_ eq $r;
      push @q,$_;
    }
#    $d{$_}=$d{$n}+1,($_ eq $r)&&(last O),push@q,$_ for grep { !exists $d{$_} } keys %{$H[$n]};
  }
  $H[$l]{$r}=1;
  $H[$r]{$l}=1;
  [ $l, $r, $d{$r} ]
}

