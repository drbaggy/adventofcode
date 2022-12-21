use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
use Data::Dumper qw(Dumper);

my($t,$n,$f,@res)=(0,0,'21.txt');

my $fn=__FILE__=~s/[^\/]*$//r.'../data/'.$f;1while($fn=~s/[^\/]*\/\.\.\///);
my $time = time;

my %fn = (
  '+' => [ sub { $_[0]+$_[1] }, sub { $_[0] - $_[1] }, sub { $_[0] - $_[1] } ],
  '-' => [ sub { $_[0]-$_[1] }, sub { $_[0] + $_[1] }, sub { $_[1] - $_[0] } ],
  '/' => [ sub { $_[0]/$_[1] }, sub { $_[0] * $_[1] }, sub { $_[1] / $_[0] } ],
  '*' => [ sub { $_[0]*$_[1] }, sub { $_[0] / $_[1] }, sub { $_[0] / $_[1] } ],
  'X' => [ sub { [] } ],
);
open my $fh,'<',$fn;
my %p = map { chomp, my @t = split /(?:: | )/; $t[0],  @t>2 ? [@t[1..3]] : $t[1] } <$fh>;
close $fh;

## Solve part 1
$n = e( 'root' );
## Update the "HUMaN" mode so it is a reference which can't be resolved
## Update the "root" action to be "-" this is effectively the same as equal if we set
## the target to 0
( $p{'humn'}, $p{'root'}[1] ) = ( [0,'X',0], '-'  );
my $z = e('root');

( $t, $z )=( $fn{ $z->[1] }[ ref $z->[0] ? 1 : 2 ]( $t, $z->[ ref $z->[0] ? 2 : 0 ] ),
             $z->[ ref $z->[0] ? 0 : 2 ]        ) while $z && @$z;

say "Time :", sprintf '%0.6f', time-$time;
say "$n\n$t";

sub e {
  my( $l, $x, $r ) = @{$p{$_[0]}};
  ( $l, $r ) = map { ref $p{$_} ? e($_) : $p{$_} } $l,$r;
  ( ref $l || ref $r ) ? [ $l, $x, $r ] : $fn{$x}[0]( $l, $r )
}

