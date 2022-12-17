use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
use Data::Dumper qw(Dumper);

my($t,$Y,$M,$f)=(0,2e6,4e6,'15.txt');
#my($t,$Y,$M,$f)=(0, 10, 20,'t-15');

my $fn=__FILE__=~s/[^\/]*$//r.'../data/'.$f;1while($fn=~s/[^\/]*\/\.\.\///);
my $time = time;

open my $fh,'<',$fn;
my @rows = map { my @t = m{(-?\d+)}g;  [@t,abs($t[0]-$t[2]) + abs($t[1]-$t[3])] } <$fh>;
close $fh;

## Find any beacons on $Y line
my %b = map { $_->[3] == $Y ? ($_->[2]=>1) : () } @rows;
my($l,$n) = (-1e9, -%b);

## Count included squares... (-# beacons);
$_->[0] > $l ? ($n+=$_->[1]-$_->[0]+1,$l=$_->[1]) : $_->[1]>$l && ($n+=$_->[1]-$l,$l=$_->[1])  for
  sort { $a->[0] <=> $b->[0] || $b->[1] <=> $a->[1] }
  map  { my $z = $_->[4] - abs($Y-$_->[1]);
            $z < 0  ? (): [ $_->[0] - $z, $_->[0] + $z ] }
  @rows;

## Now work on the nasty one which is part 2....
## We rotate the grid by 45 degrees {with scaling} - this means
## that the squares are horizontal not at 45 degrees.
##
## And we work out the line to the right of each of these squares.
## Note we uniquify those co-ordinates...
my %r  = map { $_->[1]+1 => 1 }
my @sq = map { [
   $_->[0]+$_->[1]-$_->[4],  $_->[0]+$_->[1]+$_->[4],
  -$_->[0]+$_->[1]-$_->[4], -$_->[0]+$_->[1]+$_->[4],
] } @rows;

## We then we find them within the bounds (of 0 .. 2*$M)

O:for my $X ( grep { $_ > 0 && $_ <= 2*$M } keys %r ) {
  my $B = $X > $M ? 2*$M-$X : $X;
  my $st;
  for (
    map  { [ $_->[2], $_->[3] ] }
    sort { $a->[2] <=> $b->[2] || $a->[3] <=> $b->[3] }
    grep { $_->[3] >= -$B || $_->[2] <= $B }
    grep { $_->[0] <= $X && $X <= $_->[1] } ## rule out all those that don't overlap line...
    @sq
  ) {
    $st || ($st=$_) && next;
    if($_->[0] > $st->[1]+1) {
      $t = ( $X + $_->[0] - 1 )/2 + 2e6 * ( $X - $_->[0] + 1);
      last O;
    } elsif( $_->[1] > $st->[1] ) {
      $st->[1]=$_->[1];
    }
  }
}
say "Time :", sprintf '%0.6f', time-$time;
say "$n\n$t";
