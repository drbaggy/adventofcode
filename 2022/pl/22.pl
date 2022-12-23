use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
use Data::Dumper qw(Dumper);

my($f)= $0 =~ m{(\d+)[.]pl$}; die unless $1;
my $size = @ARGV ? 4 : 50;
my $fn=__FILE__=~s/[^\/]*$//r.'../data/'.(@ARGV ? 't-'.$f : $f.'.txt');1while($fn=~s/[^\/]*\/\.\.\///);

my @dir = [1,0]; push @dir,[-$dir[-1][1],$dir[-1][0]] for 1..3;

my($t,$n,@res)=(0,0);

my $time = time;

open my $fh,'<',$fn;
my @in = map { chomp; $_ } <$fh>;
close $fh;

my @path = split /([LR])/, pop @in;
pop @in;

my($y,$x,$d) = (1,$in[0] =~ m{^(\s+)} ? 1+length$1 : 1);

my $width=0; length$_>$width && ($width=length$_) for @in;

my $height = ( my @map = ( [ (' ')x ($width+2) ],
  map( {[ @{ [' ',(split//), (' ') x $width ] }[0..($width+1)] ]} @in),
[ (' ')x ($width+2 ) ] ) ) - 2;

my @jump;
my @mx_x = '';
my @mx_y = '';
my @mn_x = '';
my @mn_y = '';
for my $r ( 1 .. $height ) {
  for my $c ( 1 .. $width ) {
    next if $map[$r][$c] eq  ' ';
    $mx_x[$r]=  $c; $mn_x[$r]||=$c;
    $mx_y[$c]=  $r; $mn_y[$c]||=$r;
  }
}
say "(@mn_x) (@mx_x) | (@mn_y) (@mx_y)";

for my $r ( 1 .. $height ) {
  for my $c ( 1 .. $width ) {
    next unless $map[$r][$c] eq '.';
    for my $d ( 0..3 ) {
      next unless $map[ $r+$dir[$d][1] ][ $r+$dir[$d][0] ] eq ' ';
      my $dest = $d==0 ? [$r,$mn_x[$r],$d]
               : $d==1 ? [$mn_y[$c],$c,$d]
               : $d==2 ? [$r,$mx_x[$r],$d]
               : $d==3 ? [$mx_y[$c],$c,$d]
               : -1;
      $jump[$d]{$r}{$c} = $map[$dest->[0]][$dest->[1]] eq '#' ? -1 : $dest;
    }
  }
}:w
:
D(@map);

sub D {
  say join '', @{$_} for @_;
}

print Dumper( \@jump );
#print Dumper(\@map);
__END__
#my %dirs;
my($width,$height,%rev,@maps,@faces) = (0,0);



my @grid = (
 [ ' ' ], map( { chomp; [' ',( split //),' ' ] } <$fh> ),
 [ ' ' ]
);

print Dumper(\@grid);exit;
__END__
while(<$fh>){
  last unless /\S/;
  m{^([ ]*)([.#]+)};
  my( $o, $x, $cols ) = ( scalar @faces, length($g)/$size, (my @l = split//,$w)/$size);
  $width = $x+$cols if $x+$cols>$width;
  for( 0..$cols-1) {
    $rev{($x+$_).','.$height} = @faces;
    push @maps,  [[splice @l,0,$size]];
    push @faces, { 'x' => $x+$_, 'y' => $height, 'n' => [],'c' => [] };
  }
  for (2..$size) {
    @l = grep {/\S/} split //,<$fh>;
    push @{$maps[$o+$_]}, [splice @l,0,$size] for 0..$cols-1;
  }
  $height++;
}

my @d = split /([LR])/,<$fh>;
close $fh;

## Now connect the faces...
for my $face (@faces) {
  for my $d (0..3) {
    my $n = [ $face->{'x'}+$dir[$d][0], $face->{'y'}+$dir[$d][1] ];
    if( exists $rev{ "$n->[0],$n->[1]"} ) {
      push @{$face->{'n'}},[$rev{"$n->[0],$n->[1]"},$d];
      push @{$face->{'c'}},[$rev{"$n->[0],$n->[1]"},$d]; ## Cube they are together....
    } else {
      ## Firstly we'll do the easy one the "torus" map...
      my ($x,$y) = @{ [[0,$face->{'y'}],[$face->{'x'},0],[$width,$face->{'y'}],[$face->{'x'},$height]]->[$d] };
      $x+= $dir[$d][0]; $y+= $dir[$d][1] while ! exists $rev{"$x,$y"};
      push @{$face->{'n'}},[$rev{"$x,$y"},$d];
      ## Now the harder ones...
    }
  }
}
if($size==4){
  $faces->[0]{'c'}[0]= [ 5,2 ];
  $faces->[0]{'c'}[2]= [ 2,1 ];
  $faces->[0]{'c'}[3]= [ 1,2 ];

  $faces->[1]{'c'}[1]= [ 4,3 ];
  $faces->[1]{'c'}[2]= [ 5,3 ];
  $faces->[1]{'c'}[3]= [ 0,1 ];

  $faces->[2]{'c'}[1]= [ 4, ];
  $faces->[2]{'c'}[3]= [ 0, ];

  $faces->[3]{'c'}[0]= [ 5, ];

  $faces->[4]{'c'}[1]= [ 1, ];
  $faces->[4]{'c'}[2]= [ 2, ];

  $faces->[5]{'c'}[0]= [ 6,0 ];
  $faces->[5]{'c'}[1]= [ 1,3 ];
  $faces->[5]{'c'}[3]= [ 3,2 ];
}

#print Dumper \@faces;

my( $D, $T, $x, $y ) = ( 0, 0, 0, 0 );
my $E = $size-1;
for my $cmd ( @d ) {
  say $faces[$T]{'x'}*$size+$x+1,' ',$faces[$T]{'y'}*$size+$y+1;
  if( $cmd eq 'R') { $D++; $D%=4; next }
  if( $cmd eq 'L') { $D--; $D%=4; next }
  for my $st (1..$cmd) {
    my($NT,$ND) = @{ $faces[$T]{'n'}[$D] };
       if( $D == 0 && $x == $E ) { last if $maps[ $NT ][$y][ 0] eq '#'; ($T,$x) = ( $NT, 0  ); }
    elsif( $D == 1 && $y == $E ) { last if $maps[ $NT ][ 0][$x] eq '#'; ($T,$y) = ( $NT, 0  ); }
    elsif( $D == 2 && $x == 0  ) { last if $maps[ $NT ][$y][$E] eq '#'; ($T,$x) = ( $NT, $E ); }
    elsif( $D == 3 && $y == 0  ) { last if $maps[ $NT ][$E][$x] eq '#'; ($T,$y) = ( $NT, $E ); }
    else {                                 last if $maps[ $T  ][ $y + $dir[$D][1] ][ $x + $dir[$D][0] ] eq '#';
      $y += $dir[$D][1]; $x += $dir[$D][0];
    }
  }
}

my $X = ($faces[$T]{'x'} * $size + $x + 1);
my $Y = ($faces[$T]{'y'} * $size + $y + 1);

say $Y*1000 + $X*4 + $D;

__END__
    my($,$w) = m{^([ ]*)([.#]+)};
  my $t
  my $col =
  unless($y) {
    push @faces, { 'map' => [] , 'row' => $row, 'col' =>


  $g=length$g;$w=2+length$w;
  push @{$dirs{'r'}}, [$g+$w-1,'.'eq$s?$g:-1];
  push @{$dirs{'l'}}, [$g,'.'eq$e?$g+$w-1:-1];
  $x = -1;
  for (split //) {
    $x++;
    next if $_ eq ' ';
    $dirs{'t'}[$x]||=[$y,,$_];
    $dirs{'b'}[$x]  =[$y,,$_];
  }
  $y++;
  push @map, [split //];
}

for(0..@{$dirs{'t'}}-1) {
  ($dirs{'t'}[$_][1],$dirs{'b'}[$_][1]) =
    ($dirs{'b'}[$_][1] eq '.' ? $dirs{'b'}[$_][0] : -1,
     $dirs{'t'}[$_][1] eq '.' ? $dirs{'t'}[$_][0] : -1);
}


foreach my $dir ( sort keys %dirs ) {
  say $dir,': ', join ', ', map{ "[@{$_}]" } @{$dirs{$dir}};
}

$y = 0; $x = $dirs{'l'}[0][0];
O: for(@d) {
  warn "** $_ **";
  if( $_ eq 'R' ) {
    $d++; $d%=4;
  } elsif( $_ eq 'L' ) {
    $d--; $d%=4;
  } else {
    for ( 1..$_ ) {
      $map[$y][$x] = ['>','v','<','^']->[$d];
      if( $d == 0 ) {      # R
        $x == $dirs{'r'}[$y][0] ? ( $dirs{'r'}[$y][1] == -1 ? next O : ($x = $dirs{'r'}[$y][1]) ) : $map[$y][$x+1] eq '#' ? next O : $x++
      } elsif( $d == 2 ) { # L
        $x == $dirs{'l'}[$y][0] ? ( $dirs{'l'}[$y][1] == -1 ? next O : ($x = $dirs{'l'}[$y][1]) ) : $map[$y][$x-1] eq '#' ? next O : $x--
      } elsif( $d == 1 ) { # D
        $y == $dirs{'b'}[$x][0] ? ( $dirs{'b'}[$x][1] == -1 ? next O : ($y = $dirs{'b'}[$x][1]) ) : $map[$y+1][$x] eq '#' ? next O : $y++
      } else {             # U
        $y == $dirs{'t'}[$x][0] ? ( $dirs{'t'}[$x][1] == -1 ? next O : ($y = $dirs{'t'}[$x][1]) ) : $map[$y-1][$x] eq '#' ? next O : $y--
      }
    }
  }
}
$map[$y][$x] = ['R','D','L','U']->[$d];

my $c='000';
say ++$c,' ',@{$_} for @map;
say $y+1,' ',$x+1,' ',$d,' ',1004 + $y * 1000 + $x * 4 + $d;

say "@d";

#print Dumper(\%dirs);

say scalar grep { /R/ } @d;
say scalar grep { /L/ } @d;
say "Time :", sprintf '%0.6f', time-$time;
say "$n\n$t";

