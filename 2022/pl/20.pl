use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
use Data::Dumper qw(Dumper);

#my($t,$n,$f,$p,@res)=(0,0,'t-20');
my($t,$n,$f,$p,@res)=(0,0,'20.txt');

my $fn=__FILE__=~s/[^\/]*$//r.'../data/'.$f;1while($fn=~s/[^\/]*\/\.\.\///);
my $time = time;

open my $fh,'<',$fn;
my $l = my @in = map { int $_ } grep { /\S/ } <$fh>;
close $fh;

for ( [1,1] , [10,811589153] ) {
  my $c = 0;
  my( $m1, @state ) = ( (my $mult = $_->[1])%($l-1), map { [$c++,$_] } @in );
  for( 1 .. $_->[0] ) {
    for( 0..$#in ) {
      $p = 0; $p++ while $state[$p][0]!=$_;
      my $t = splice @state, $p, 1;
      splice @state, ($in[$_]*$mult+$p)%($l-1), 0, $t;
    }
  }
  $p = 0; $p++ while $state[$p][1];
  push @res, $mult * ( $state[ ($p+1e3)%$l ][1] +$state[ ($p+2e3)%$l ][1] +$state[ ($p+3e3)%$l ][1] );
}

say "Time :", sprintf '%0.6f', time-$time;
say for @res;

