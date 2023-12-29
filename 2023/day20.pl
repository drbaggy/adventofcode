#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
use lib qw(mods);

use Machine;
use Math::Prime::Util qw(lcm);

my($t0,$t1,$t2)=(time,0,1);

my $machine = Machine->new;
while(<>) {
  chomp;
  next unless m{([%&]?)(\w+) -> (.*)};
  my( $t, $n, @x ) = ( $1 || '+', $2, split /,\s*/, $3 );
  $t = $t eq '%'           ? 'FlipFlop'
     : $t eq '&'           ? 'Conjunction'
     : $n eq 'broadcaster' ? 'Broadcaster'
     :                       'Output'
     ;
  $machine->add_node( $t, $n, @x );
}
$machine->sort_out_conjunction_inputs;
$machine->find_and_add_output_nodes;
#print Dumper( $machine );exit;

$machine->press_button for 1..1000;
$t1 = $machine->prod;
$machine->reset;


my %sequence = ();
for(1..15000) {
  $machine->press_button;
  next unless exists $machine->{'memory'}{'returns'};
  last unless grep { $_ < 2 } map { scalar @{$_} } values %{$machine->{'memory'}{'returns'}};
}

$t2=lcm( map { $_->[1][1] } values %{ $machine->{'memory'}{'returns'} } );


printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

