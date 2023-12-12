#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
use Data::Dumper qw(Dumper);
use Math::Prime::Util qw(lcm);

my($t0,$t1,$t2) = (time,0,0);

my ($c,@i,@r,%x,@c,@e) = (0,map{ 'L'eq$_ ? 0 : 1 } <> =~ /([LR])/g );
my %r = map { m{(\w+).*?(\w+).*?(\w+)} ? ( $1 => [$2,$3] ) : () } <>;
my @K = keys %r;
@x{@K} = 0 .. $#K;
my $z  = $x{'ZZZ'};


@r[ map{$x{$_}} @K ] = map { [ $x{$r{$_}[0]}, $x{$r{$_}[1]} ] } @K;
my @l = map { $x{$_} } grep { m{..A} } grep { m{..Z} ? $e[$x{$_}]=1 : 1 } keys %r;

unshift @i, pop @i;
@l = map { $e[ $_ = $r[$_][$i[$c%@i]] ] ? ( $z == $_ && ($t1=$c), push @c,$c ) && () : $_ } @l while ++$c && @l;
$t2 = lcm @c;


printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

