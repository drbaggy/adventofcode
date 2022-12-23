use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
use Data::Dumper qw(Dumper);

my($t,$Z,$moved,$n) = (0,100,1);

my($f)= $0 =~ m{(\d+)[.]pl$}; die unless $f;
$Z = 10 if @ARGV;

my $fn=__FILE__=~s/[^\/]*$//r.'../data/'.(@ARGV ? 't-'.$f : $f.'.txt');1while($fn=~s/[^\/]*\/\.\.\///);
my $time = time;

open my $fh, '<', $fn;
my @M = map {chomp; [ ('.')x $Z, (split//), ('.')x $Z] } <$fh>;
close $fh;

my $W = @{$M[0]};
unshift @M, [ ('.')x $W ] for 1..$Z; push @M, [ ('.')x $W ] for 1..$Z;
my $H = @M;
my @D = ([-1,0,'$',224],[1,0,'%',7],[0,-1,'&',148],[0,1,'*',41]);
my %M = map { $_->[2], $_ } @D;
my %F = map {$_=>1} qw(. 1 2);

## @V is the location of the elves
my @V;
for my $y ($Z .. $H-$Z) {
  for my $x ($Z .. $W-$Z) {
    push @V, [$x,$y] if $M[$y][$x]eq'#';
  }
}

while($moved) {
  ## Sweep 1 look for potential moves...
  for (@V) {
    my($x,$y) = @{$_};
    next unless my $s =
              ($M[$y+1][$x+1] lt '+') +   2 * ($M[$y+1][$x  ] lt '+') +   4 * ($M[$y+1][$x-1] lt '+') +   8 * ($M[$y  ][$x+1] lt '+')
      +  16 * ($M[$y  ][$x-1] lt '+') +  32 * ($M[$y-1][$x+1] lt '+') +  64 * ($M[$y-1][$x  ] lt '+') + 128 * ($M[$y-1][$x-1] lt '+');
    for( @D ) {
      my($d,$e,$v,$w)=@{$_};
      unless( $w & $s ) {
        ($M[$y][$x],$M[$y+$d][$x+$e]) = ($v, $M[$y+$d][$x+$e] ne '1' ? 1 : 2);
        last;
      }
    }
  }
  ## Sweep 2 - now perform the moves and reset the grid!
  $moved = 0;
  for(0..$#V) {
    my($x,$y) = @{$V[$_]};
    next if $M[$y][$x] eq '#'; # Don't move!
    my($nx,$ny) = ( $x + $M{$M[$y][$x]}[1],  $y + $M{$M[$y][$x]}[0] );
    if( $M[$ny][$nx] ne '1' ) {
      ($M[$ny][$nx],$M[$y][$x]) = ('.','#');
      next;
    }
    $moved = 1;
    ($M[$ny][$nx],$M[$y][$x]) = ('#','.');
    $V[$_]=[$nx,$ny];
  }
  if(++$t==10){ ## Get the bounding box at 10!
    my($r,$b,$l,$z)=(0,0,$W,$H);
    for(@V) {
      $l = $_->[0] if $_->[0] < $l; $b = $_->[1] if $_->[1] > $b;
      $r = $_->[0] if $_->[0] > $r; $z = $_->[1] if $_->[1] < $z;
    }
    $n = (1+$b-$z)*($r-$l+1)-@V;
  }
  push @D, shift @D;
}

say "Time :", sprintf '%0.6f', time-$time;
say "$n\n$t";

