use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
use Data::Dumper qw(Dumper);

#my($t,$n,$f,$mx,$my,$mz,@grid)=(0,0,'t-18',0,0,0);
my($t,$n,$f,$mx,$my,$mz,@grid)=(0,0,'18.txt',0,0,0);

my $fn=__FILE__=~s/[^\/]*$//r.'../data/'.$f;1while($fn=~s/[^\/]*\/\.\.\///);
my $time = time;

open my $fh,'<',$fn;
$grid[$_->[0]+1][$_->[1]+1][$_->[2]+1]=2,
$_->[0] > $mx && ($mx = $_->[0]),
$_->[1] > $my && ($my = $_->[1]),
$_->[2] > $mz && ($mz = $_->[2]) for my @rows = map { chomp;[map{int$_}split/,/] } <$fh>;
close $fh;
$mx+=2,$my+=2,$mz+=2,$n=6*@rows;

for ( @rows ) {
  $n-- if $grid[$_->[0]  ][$_->[1]+1][$_->[2]+1];
  $n-- if $grid[$_->[0]+1][$_->[1]  ][$_->[2]+1];
  $n-- if $grid[$_->[0]+1][$_->[1]+1][$_->[2]  ];
  $n-- if $grid[$_->[0]+2][$_->[1]+1][$_->[2]+1];
  $n-- if $grid[$_->[0]+1][$_->[1]+2][$_->[2]+1];
  $n-- if $grid[$_->[0]+1][$_->[1]+1][$_->[2]+2];
}

my @q = ([0,0,0]);
while( $_ = shift @q ) {
  my($x,$y,$z) = @{$_};
  $t++ if (my $v = $grid[$x][$y][$z]||0) == 2;
  next if $v;
  $grid[$x][$y][$z]=1;
  push @q,$z     ? [$x,$y,$z-1] : (), $z<$mz ? [$x,$y,$z+1] : (),
          $y     ? [$x,$y-1,$z] : (), $y<$my ? [$x,$y+1,$z] : (),
          $x     ? [$x-1,$y,$z] : (), $x<$mx ? [$x+1,$y,$z] : ();
}

say "Time :", sprintf '%0.6f', time-$time;
say "$n\n$t";

