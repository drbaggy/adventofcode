#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
#use Data::Dumper qw(Dumper);

my($t0,$t1,$t2)=(time,0,0);

my %M = qw(UU | UR F UD . UL 7 RU J RR - RD 7 RL .  DU . DR L DD | DL J LU L LR . LD F LL -);

## Convert map into numeric array of weights..., get dimensions
my @i = map { m{([RDUL]) (\d+) \(#([0-9a-f]{5})([0123])\)} ? [$1,$2,['R','D','L','U']->[$4],hex("0x$3")] : () } <>;

#print Dumper(\@i);exit;
my($min_r,$min_c)=my($max_r,$max_c)=my($r,$c)=(0,0);

my(%Rs,%Cs,$p);

## Part 1 ===========================================================

## Get bounds
for(@i) {
  $c+=$_->[1]*( $_->[0] eq 'R' ? 1 : $_->[0] eq 'L' ? -1 : 0 ); $r+=$_->[1]*( $_->[0] eq 'D' ? 1 : $_->[0] eq 'U' ? -1 : 0 ); ## Move
  $min_r = $r if $r < $min_r; $max_r = $r if $r > $max_r; $min_c = $c if $c < $min_c; $max_c = $c if $c > $max_c;             ## Check bounds
}

## Create empty grid
my @g = map { [ map { ' ' } 0 .. $max_c-$min_c ] } 0..$max_r-$min_r;
## Get start square {and previous direction - its a loop so last value}
($r,$c,$p)=(-$min_r,-$min_c,$i[-1][0]);
for my $i (@i) {
  $g[ $r ][ $c ] = $M{ $p.$i->[0] }; ## Put previous turn symbol....
  $g[ $r += $i->[0] eq 'D' ? 1 : $i->[0] eq 'U' ? -1 : 0 ]
    [ $c += $i->[0] eq 'R' ? 1 : $i->[0] eq 'L' ? -1 : 0 ] = $i->[0] eq 'R' || $i->[0] eq 'L' ? '-' : '|' for 1..$i->[1];
  $p = $i->[0], $t1 += $i->[1];
}
$g[$r][$c] = $M{$p.$i[0][0]};

## Now flood fill...
for (@g) {
  my @parts = (join '',@{$_}) =~ s{(?:F-*7|L-*J)}{}gr =~ m{(\s*)\S*}g; ## Remove F----7 & L----J where w don't cross the line!!
  while(@parts) { ## each of these are whitespace - first is without the grid - 2nd within - 3rd without, 4th within...
    shift @parts;
    $t1+= length shift @parts if @parts
  }
}

## Part 2 ===========================================================

## Get bounds & grid lines....
($min_r,$min_c)=($max_r,$max_c)=($r,$c)=(0,0);
for(@i) {
  $c+=$_->[3]*( $_->[2] eq 'R' ? 1 : $_->[2] eq 'L' ? -1 : 0 ); $r+=$_->[3]*( $_->[2] eq 'D' ? 1 : $_->[2] eq 'U' ? -1 : 0 ); ## Move
  $Rs{$r}=1;$Cs{$c}=1;                                                                                                        ## record lines
  $min_r = $r if $r < $min_r; $max_r = $r if $r > $max_r; $min_c = $c if $c < $min_c; $max_c = $c if $c > $max_c;             ## check bounds
  $t2 += $_->[3];
}

# Generate a series of block lengths - either containing a line s=e or a block s!=e
$p=-1; my @gr = grep { $_->[1]>=$_->[0] } map { [$p+1,$_-1,$_-$p-1],[$_,$p=$_,1] } sort {$a<=>$b} keys %Rs; ## Get "blocks" in order...
$p=-1; my @gc = grep { $_->[1]>=$_->[0] } map { [$p+1,$_-1,$_-$p-1],[$_,$p=$_,1] } sort {$a<=>$b} keys %Cs;
@g = map { [ map { ' ' } @gc ] } @gr;

## Lets start by walking the grid....
($r,$c,$p)=( scalar grep( {$_->[0]<0} @gr ), scalar grep( {$_->[0]<0} @gc ), $i[-1][2] );
#exit;
for (@i) {
  my($d,$x) = ($_->[2],$_->[3]);
  $g[ $r ][ $c ] = $M{ $p.$d }; ## Put previous turn symbol....
  if(    $d eq 'R' ) { $x += $gc[$c][0];      $g[$r][++$c]='-' while $gc[$c][0]!=$x }
  elsif( $d eq 'L' ) { $x  = $gc[$c][0] - $x; $g[$r][--$c]='-' while $gc[$c][0]!=$x }
  elsif( $d eq 'D' ) { $x += $gr[$r][0];      $g[++$r][$c]='|' while $gr[$r][0]!=$x }
  elsif( $d eq 'U' ) { $x  = $gr[$r][0] - $x; $g[--$r][$c]='|' while $gr[$r][0]!=$x }
  $p = $d;
}
$g[ $r ][ $c ] = $M{ $p.$i[0][2] }; ## Put previous turn symbol....
## Now we fill the grid...
my @A;
$r = 0;
for (@g) {
  my $i = $c = 0;
  $t2 += $gr[$r][2]*$gc[$c++][2]*('1'eq$_) for
    split //,
    join '',
    map {
      m{\S} ? ( ( m{(F-*7|L-*J)} || ($i=1-$i) ) x 0, $_ )
            : ( $i ? '1' x length $_ : $_ )
    }
    split m{(\||[FL]-*[J7])},
    join '',
    @{$_};
  $r++;
}

printf "%16s %16s %15.9f\n", $t1, $t2, time-$t0;

