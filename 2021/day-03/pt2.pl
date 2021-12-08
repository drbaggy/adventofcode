#!/usr/bin/perl

use strict;
use warnings;
use feature qw(say);
use Data::Dumper qw(Dumper);

my @nos = <>;
chomp @nos;
my @nos2 = @nos;
my $res = 0;
while( length $nos[0] > 0 ) {
  my $c = 0;
  $c += -48 + ord $_ foreach @nos;
  my $f = 2*$c >= @nos ? 1 : 0;
  $res *=2;
  $res ++ if $f;
  @nos = map { m{(.)(.*)} ? ( $1 == $f ? $2 : () ) : () } @nos;
}
my $res2 = 0;
while( length $nos2[0] > 0 ) {
  my $c = 0;
  $c += -48 + ord $_ foreach @nos2;
  my $f = 2*$c >= @nos2 ? 1 : 0;
  $f = 1-$f if @nos2==1;
  $res2 *=2;
  $res2 ++ unless $f;
  if(@nos2==1) {
    @nos2 = map { m{(.)(.*)} ? $2 : () } @nos2;
  } else {
    @nos2 = map { m{(.)(.*)} ? ( $1 == $f ? () : $2 ) : () } @nos2;
  }
}


warn $res,' ',$res2;
warn $res*$res2;
exit;
__END__
my @bits;
my $c=0;
while(<>) {
  $c++;
  chomp;
  my $i=0;
  $bits[$i++] += $_ foreach split //, $_;
}

my $N = 1 << scalar @bits;
my $gamma = 0;
$gamma = ($gamma <<1) + ( (shift @bits) > $c/2 ? 1 : 0 ) while @bits;
my $epsilon = $N - 1 - $gamma;

say $epsilon * $gamma;
