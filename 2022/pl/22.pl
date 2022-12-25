use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
use Data::Dumper qw(Dumper);
$Data::Dumper::Sortkeys=1;
my($f)= __FILE__ =~ m{(\d+)[.]pl$}; die unless $1;
my $fn=__FILE__=~s/[^\/]*$//r.'../data/'.(@ARGV ? 't-'.$f : $f.'.txt');1while($fn=~s/[^\/]*\/\.\.\///);

my(@dir,@res) = ([1,0]); push @dir,[-$dir[-1][1],$dir[-1][0]] for 1..3;

my $time = time;

open my $fh,'<',$fn;
my @in = map { chomp; $_ } <$fh>;
close $fh;

my @path = split /([LR])/, pop @in;
pop @in;
my $width=0; length$_>$width && ($width=length$_) for @in;

my $height = ( my @map = ( [ (' ')x ($width+2) ],
  map( {[ @{ [' ',(split//), (' ') x $width ] }[0..($width+1)] ]} @in),
[ (' ')x ($width+2 ) ] ) ) - 2;

my $size = $height*3==$width*4 ? $width/3
         : $height*4==$width*3 ? $height/3
         : $height*5==$width*2 ? $width/5
         :                       $height/5
         ;

#my @net = map { my $k=$_; [ map{ $map[1+$k*$size][1+$_*$size] eq ' ' ? 0 : 1 } 0..$width/$size-1 ] } 0..$height/$size-1;
## To help with cube finding!!!!!

## Find the boundary points - we can use this for the toroidal calculation....
my (@jump, @cube, @mx_x, @mx_y, @mn_x, @mn_y);
for my $r ( 1 .. $height ) {
  for my $c ( 1 .. $width ) {
    next if $map[$r][$c] eq  ' ';
    $mx_x[$r]=  $c; $mn_x[$r]||=$c;
    $mx_y[$c]=  $r; $mn_y[$c]||=$r;
  }
}

## This is how we join the cubest together!!!

my @cube_join = (
  [ undef,                                  [ undef,   undef,   [2,0,0], [3,0,0] ], [ [2,1,2], [1,1,2], undef,   [3,0,3] ] ],
  [ undef,                                  [ [0,2,3], undef,   [2,0,1], undef   ], undef                                  ],
  [ [ undef,   undef,   [0,1,0], [1,1,0] ], [ [0,2,2], [3,0,2], undef,   undef   ], undef                                  ],
  [ [ [2,1,3], [0,2,1], [0,1,1], undef   ], undef,                                  undef                                  ],
);
if($size == 4 ) { @cube_join = (
  [ undef,                                undef,                              [ [2,3,2], undef,   [1,1,1], [1,0,1] ], undef                                ],
  [ [ undef, [2,2,3], [2,3,3], [0,2,1] ], [ undef, [2,2,0], undef, [0,2,0] ], [ [2,3,1], undef,   undef,   undef   ], undef                                ],
  [ undef,                                undef,                              [ undef,   [1,0,3], [1,1,3], undef   ], [ [0,2,2], [1,0,0], undef, [1,2,2] ] ]
) }

## Generate jump maps for the two "folds" of the map - when you jum off into space where do you go...
## @jump is for the toroidal map - and just rotates to the other side
## @cube is for the cube map - and requires a fold map is generated {hand crafted above}

for my $r ( 1 .. $height ) {
  my $fr = int(($r-1)/$size);
  for my $c ( 1 .. $width ) {
    next unless $map[$r][$c] eq '.';
    my $fc = int(($c-1)/$size);
    for my $d ( 0..3 ) {
      next if $map[ $r+$dir[$d][1] ][ $c+$dir[$d][0] ] ne ' ';
      my $dest = $d==0 ? [ $r,        $mn_x[$r], $d ]
               : $d==1 ? [ $mn_y[$c], $c,        $d ]
               : $d==2 ? [ $r,        $mx_x[$r], $d ]
               : $d==3 ? [ $mx_y[$c], $c,        $d ]
               : -1;
      $jump[$d]{$c}{$r} = $map[$dest->[0]][$dest->[1]] eq '#' ? undef : $dest;
## Cubic map
      my($dr,$dc,$dd) = @{ $cube_join[ $fr ][ $fc ][ $d ] };
      my $pos = $d == 0 ? $r - $fr * $size - 1
              : $d == 1 ? ($fc+1)*$size - $c
              : $d == 2 ? ($fr+1)*$size - $r
              :           $c - $fc * $size - 1
              ;
      my($nr,$nc) = $dd == 0 ? ( $dr * $size + 1 + $pos, $dc * $size + 1        )
                  : $dd == 1 ? ( $dr * $size + 1,          ($dc+1)*$size - $pos   )
                  : $dd == 2 ? ( ($dr+1)*$size - $pos,   ( $dc+1) * $size       )
                  :            ( ($dr+1)*$size,        $dc * $size + 1 + $pos )
                  ;
      $cube[$d]{$c}{$r} = $map[$nr][$nc] eq '#' ? undef : [$nr,$nc,$dd,$pos];
    }
  }
}


## Follow path using jump maps....

for my $jumps ( \@jump, \@cube ) {
  my($r,$c,$d) = (1,$mn_x[1],0);
  for( @path ) {
    $_ eq 'R' ? ($d++,$d%=4) :
    $_ eq 'L' ? ($d--,$d%=4) :
    map { exists $jumps->[$d]{$c}{$r}
    ? defined $jumps->[$d]{$c}{$r} ? ($r,$c,$d) = @{$jumps->[$d]{$c}{$r}} : next
    : $map[ $r+$dir[$d][1] ][ $c+$dir[$d][0] ] eq '.' ? ($r+=$dir[$d][1],$c+=$dir[$d][0]) : next
    } 1..$_
  }
  push @res, $r * 1000 + $c * 4 + $d;
}

say "Time :", sprintf '%0.6f', time-$time;
say for @res;
