use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
use Data::Dumper qw(Dumper);

#my($t,$n,$f,$mx,$my,$mz,@g)=(0,0,'t-18',0,0,0,[[[1]]]);
my($t,$n,$f,$mx,$my,$mz,@g)=(0,0,'18.txt',0,0,0,[[[1]]]);

my $fn=__FILE__=~s/[^\/]*$//r.'../data/'.$f;1while($fn=~s/[^\/]*\/\.\.\///);
my $time = time;

open my $fh,'<',$fn;
$g[$_->[0]+1][$_->[1]+1][$_->[2]+1]=2,
$_->[0] > $mx && ($mx = $_->[0]),
$_->[1] > $my && ($my = $_->[1]),
$_->[2] > $mz && ($mz = $_->[2]) for my @rows = map { chomp; [map{int$_}split/,/] } <$fh>;
close $fh;
$mx+=2,$my+=2,$mz+=2,$n=6*@rows;

for ( @rows ) {
  $n-- if $g[$_->[0]  ][$_->[1]+1][$_->[2]+1];
  $n-- if $g[$_->[0]+1][$_->[1]  ][$_->[2]+1];
  $n-- if $g[$_->[0]+1][$_->[1]+1][$_->[2]  ];
  $n-- if $g[$_->[0]+2][$_->[1]+1][$_->[2]+1];
  $n-- if $g[$_->[0]+1][$_->[1]+2][$_->[2]+1];
  $n-- if $g[$_->[0]+1][$_->[1]+1][$_->[2]+2];
}

my @q = ([0,0,0]);
while(my($x,$y,$z)=@{shift@q||[]}) {
  if( $z     ) { if( $g[$x][$y][$z-1] ) { $t++ if $g[$x][$y][$z-1]==2; } else { $g[$x][$y][$z-1]=1; push @q,[$x,$y,$z-1] } }
  if( $z<$mz ) { if( $g[$x][$y][$z+1] ) { $t++ if $g[$x][$y][$z+1]==2; } else { $g[$x][$y][$z+1]=1; push @q,[$x,$y,$z+1] } }
  if( $y     ) { if( $g[$x][$y-1][$z] ) { $t++ if $g[$x][$y-1][$z]==2; } else { $g[$x][$y-1][$z]=1; push @q,[$x,$y-1,$z] } }
  if( $y<$mx ) { if( $g[$x][$y+1][$z] ) { $t++ if $g[$x][$y+1][$z]==2; } else { $g[$x][$y+1][$z]=1; push @q,[$x,$y+1,$z] } }
  if( $x     ) { if( $g[$x-1][$y][$z] ) { $t++ if $g[$x-1][$y][$z]==2; } else { $g[$x-1][$y][$z]=1; push @q,[$x-1,$y,$z] } }
  if( $x<$mx ) { if( $g[$x+1][$y][$z] ) { $t++ if $g[$x+1][$y][$z]==2; } else { $g[$x+1][$y][$z]=1; push @q,[$x+1,$y,$z] } }
}

say "Time :", sprintf '%0.6f', time-$time;
say "$n\n$t";

