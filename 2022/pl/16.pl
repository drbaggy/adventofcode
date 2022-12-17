use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
use Data::Dumper qw(Dumper);

my $f ='16.txt';
my $fn=__FILE__=~s/[^\/]*$//r.'../data/'.$f;1while($fn=~s/[^\/]*\/\.\.\///);

my($time,@times) = time;
my ($i, $t, @v, @map, %ix, @nd, %mp, %ch )=(0,0);

## Load in data...
##----------------

open my $fh,'<',$fn;
while(<$fh>) {
  m{Valve (\w+).*rate=(\d+).*valves? (.*)};
  $mp{ $1 }{ $_ } = $mp{ $_ }{ $1 } = 1 for split /, /,$3;
  if( $2 > 0 || $1 eq 'AA' ) {
    my $t = $ix{ $1 } ||= $1 eq 'AA' ? 0 : ++$i;
    $v[   $t ]       = $2;
    $map[ $t ]       = $1;
    $nd[  $t ][ $t ] = 0
  }
}
close $fh;

## Simplify data....
##------------------

push @times,time;
discovery(     $_, $map[$_], 0, '' ) for 0..$i;  ## Find walks to nearest "node"

#d();
push @times,time;
discovery_pt2( );                                ## Find shortest walk to all "nd"
#d();

sub d {
  say '   ', join ' ', @map;
  foreach my $k (0..$#map) {
    say $map[$k], map { $nd[$k][$_] ? sprintf ' %2d', $nd[$k][$_] : '  .' } 0..$#map
  }
}
## Part 1 - walk (plus prep ch for part 2)
##-------------------------------------------

push @times,time;
my $n = walk( 30, 0, 0, 0, 0 .. $i );            ## Walk the human walk (but cache data
                                                 ## for part 2...)
## Part 2 - merge walks to find best
##----------------------------------

#my @K = map { $_*1 } keys %ch;                   ## get the keys of the cache and convert
                                                 ## to numbers
push @times,time;
my @K = sort { $ch{$b} <=> $ch{$a} || $a <=> $b } keys %ch;
while( my $k = shift @K ) {  ## Loop through the cache to find pairs of disjoint keys
  last if 2*(my $p=$ch{$k})<=$t;         ## whose values have the largest sum..
  $p+$ch{$_}<=$t ? last : $k&$_ || ($t=$ch{$_}+$p)  for @K
}
push @times,time;

## Now output times etc....
##-------------------------
say "Time :", sprintf '%0.6f', time-$time;
say "$n\n$t";
## my $pt = $time; say(sprintf '%10.6f %10.6f', $_-$pt, $_-$time),($pt=$_) for @times;

## Our walk routine....
##---------------------

sub walk {
  my( $ht, $pt, $pr, $pr2, $x, @n ) = @_;
  my $p = $pr;
  for(1..@n) {
    my $y = shift @n;
    my $h  = $ht - $nd[$x][$y]-1;
    if( $h > 0 ) {
      if( $h < 5 ) {
        my $v = walk( $h, $pt, $pr + $h*$v[$y], $pr2, $y, @n );
        $p = $v if $v > $p
      } else {
        my($p2,$np2) = ( $pt | 1<<$y, $pr2 + ($h-4)*$v[$y] );
        $ch{ $p2 } = $np2 unless exists $ch{$p2} && $np2 <= $ch{ $p2 };
        my $v = walk( $h, $p2, $pr + $h*$v[$y], $np2, $y, @n );
        $p = $v if $v > $p
      }
    }
    push @n,$y
  }
  $p
}

## Discovery part 1. - find distances between adjacent valves
##----------------------------------------------------------------

sub discovery {
  my( $r, $c, $l, $p ) = @_;
  if( $l && exists $ix{$c} ) {
    $nd[$r][$ix{$c}] = $nd[$ix{$c}][$r] = $l
      unless $nd[$ix{$c}][$r] && $nd[$ix{$c}][$r] > $l;
    return
  }
  discovery( $r, $_, $l+1, $c ) for grep { $_ ne $p } keys %{$mp{$c}}
}

## Discovery part 2. Find the shortest distance between each pair of valves..
##---------------------------------------------------------------------------

sub discovery_pt2 {
  for my $x (0..$i) {
    my $u = 1;
    while( $u ) {
      $u = 0;
      for my $y (0..$i) {
        next if $x==$y || ! $nd[$x][$y];
        for (0..$i) {
          next if $_==$y || $_==$x || ! $nd[$y][$_];
          my $t = $nd[$x][$y] + $nd[$y][$_];
          ($nd[$x][$_],$u)=($t,1) unless $nd[$x][$_] && $nd[$x][$_] <= $t
        }
      }
    }
  }
}
