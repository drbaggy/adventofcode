#!/usr/bin/perl

use strict;
use warnings;
use feature qw(say);
use Data::Dumper qw(Dumper);

my $c = 0;
my @N = split /,/, <>;
my @cards;
my %seen;
my @matches = (
  ( map { 31 << (5*$_)    } 0..4 ),
  ( map { 1_082_401 << $_ } 0..4 ),
);
while(<>) {
  chomp;
  if( m{\d} ) {
    push @{$cards[-1][0]}, split;
  } else {
    push @cards,[[],{},0];
  }
}
foreach $c (@cards) {
  my $n=0;
  $c->[1]{$_} = $n++ foreach @{$c->[0]};
}

my $n;

while(@N) {
  $n = shift @N;
  $seen{$n}=1;
  my @t_cards;
  CARD: foreach my $c ( @cards ) {
    #warn "** $n ***";
    if( exists $c->[1]{$n} ) {
      $c->[2] |= (1<<$c->[1]{$n});
      foreach(@matches) {
        next unless ($c->[2] & $_ ) == $_;
        next CARD;
      }
    }
    push @t_cards,$c;
  }
  @cards = @t_cards;
  warn "$n - ",scalar @cards, "\n";
  last if @cards == 1;
}
my $t = -$N[0];
$c = $cards[0];
$t+=$_ foreach grep { !$seen{$_} } @{$c->[0]};
##      my @T = @{$c->[0]};
##      while(my @Q = splice @T,0,5) {
##        printf '%2d%s   ', $_, $seen{$_}?'*':' ' foreach @Q;
##        print "\n";
##      }
say $t, ' x ', $N[0];
say $t*$N[0]; exit;

say Dumper( \@cards );
