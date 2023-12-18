#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
#use Data::Dumper qw(Dumper);

my($t0,$t1,$t2)=(time,0,0);

my(@l,$L);
my @in = <>; push @in, '';

for(@in) {
  chomp;
  $_ && ( push( @l, $_), next );
  $L = -1 + length $l[0];
  my ($v,$h) = score(0,0);
  $t1 += $v*100+$h;
  my(%vc,%hc);
  Z: for my $y ( 0 .. $#l ) {
    for my $x (  0 .. $L  ) {
      my $t = substr $l[$y],$x,1;   substr $l[$y],$x,1,$t eq '#' ? '.' : '#';
      my($V,$H) = score($v,$h);     substr $l[$y],$x,1,$t;
      $t2 += 100*$V+$H, last Z if $V||$H;
    }
  }
  @l=();
}

sub score {
  my $vs = shift, my $hs = shift, my @r = map { scalar reverse $_ } @l;

  my($vo,$ho)=(0,0);

  O: for my $v (1..$#l) {
    my $h = $v <= ($#l-$v) ? $v : $#l-$v+1;
    ($l[$_] eq $l[2*$v-$_-1]) || next O for ($v<=$#l/2 ? 0 : 2*$v-$#l-1) .. $v-1;
    $vs == $v || ( $vo=$v, last );
  }
  P: for my $z ( 1 .. $L ) {
    my $w = $z <= ($L-$z) ? $z : $L-$z+1;
    my ($sl,$ch,$sr) = ( $z-$w, $w, $L-$z-$w+1 ); $sr = 0 if $sr<0;
    substr( $l[$_], $sl,$w ) eq substr( $r[$_],$sr,$w ) || next P for 0..$#l;
    $hs == $z || ( $ho=$z, last );
  }
  return ($vo,$ho);
}

printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

