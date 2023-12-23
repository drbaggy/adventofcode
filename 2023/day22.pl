#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
#use Data::Dumper qw(Dumper);

my($t0,$t1,$t2)=(time,0,0);

my($n,@bricks,@g,%LINK,%REV) = (0,[]);

## Locate bricks store positions and create grid!!
while(<>) {
  ## Parse input
  my( $x,$y,$z, $x2,$y2,$z2 ) = m{(\d+)}g;
  ## Ensure start is below end
    ( $x,$y,$z, $x2,$y2,$z2 ) = ( $x2,$y2,$z2, $x,$y,$z ) if $z2 < $z;
  ## Get length and "direction"
  my( $l, $dz, $dy, $dx ) = ( abs( $z2-$z || $y2-$y || $x2-$x ),
                                   $z2<=>$z, $y2<=>$y, $x2<=>$x );
  $n++;
  ## "Place" brick...
                     $g[ $z+$dz*$_   ][ $y+$dy*$_ ][ $x+$dx*$_ ] = $n for 0..$l;
  push @bricks, [ $z,$y,$x, $dz,$dy,$dx, $l ];
}

## Drop lowest first - so we only have to pass once.....
for my $I ( sort { $bricks[$a][0] <=> $bricks[$b][0] } 1 .. $#bricks ) {
  my( $z,$y,$x, $dz,$dy,$dx, $l ) = @{$bricks[$I]};
  ## "Remove" brick...
                     $g[ $z+$dz*$_   ][ $y+$dy*$_ ][ $x+$dx*$_ ] = 0  for 0..$l;
  ## "Drop" brick...
  D: while(1) {
    my $settle=0;
    for( 0 .. $l ) {
      last D if          $z+$dz*$_-1 < 1; ## Can only drop if 2 or more above ground
      next unless    $g[ $z+$dz*$_-1 ][ $y+$dy*$_ ][ $x+$dx*$_ ]         ;
      ## Settle is true if the brick can no longer move and is resting on another
      ## brick...
      $settle=
        $LINK{ $I }{ $g[ $z+$dz*$_-1 ][ $y+$dy*$_ ][ $x+$dx*$_ ] }       =
        $REV{        $g[ $z+$dz*$_-1 ][ $y+$dy*$_ ][ $x+$dx*$_ ] }{ $I } = 1;
    }
    last D if $settle;
    $z--;
  }
  ## "Put back" brick...
                     $g[ $z+$dz*$_   ][ $y+$dy*$_ ][ $x+$dx*$_ ] = $I for 0..$l;
  $bricks[$I][0] = $z;
}

## LINK contains a list of bricks which are supporting brick I
## REV  contains a list of bricks which are sitting on top of brick I

for my $I ( 1 .. $#bricks ) { ## This is the first brick we are going to remove...
  my %link = map { $_ => { %{$LINK{$_}} } } keys %LINK; ## We destroy link so make a copy..
  my( $c, @q, $i ) = ( -1, $I );
  while(@q) {
    ## Remove current brick from stack...
    delete $link{$_}{$i} for my @L = keys %{$REV{$i = shift @q}};
    ## Push bricks onto stack if they are no-longer supported...
    push @q, grep { ! keys %{$link{$_}} } @L;
    $c++;
  }
  $c ? $t2+=$c : $t1++;
}


printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

