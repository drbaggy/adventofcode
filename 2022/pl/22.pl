use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
use Data::Dumper qw(Dumper);
$Data::Dumper::Sortkeys=1;
my($fx)= __FILE__ =~ m{(\d+)[.]pl$}; die unless $1;
my $fn=__FILE__=~s/[^\/]*$//r.'../data/'.(@ARGV ? 't-'.$fx:$fx.'.txt');1while($fn=~s/[^\/]*\/\.\.\///);
my $time = time;

my(@D,@R) = ([1,0]); push @D,[-$D[-1][1],$D[-1][0]] for 1..3;
open my$fh,'<',$fn;my@I=map{chomp;$_}<$fh>;close$fh;my@P=split/([LR])/,pop@I;pop@I;
my($w,@G)=(0,[0,1],[1,2],[2,3],[3,0],[1,0],[0,3],[3,2],[2,1]);length$_>$w&&($w=length$_)for@I;
my$h=(my@M=([(' ')x($w+2)],map({[@{[' ',(split//),(' ')x$w]}[0..$w+1]]}@I),[(' ')x($w+2)]))-2;
my$S;($h*$_->[0]==$w*$_->[1])&&($S=$w/$_->[0])for[3,4],[4,3],[2,5],[5,2];
die'Nets must be 3x4 or 2x5'unless$S;
my$H=$h/$S-1;my$W=$w/$S-1;my@N=map{my$k=$_;[map{$M[1+$k*$S][1+$_*$S]eq' '?0:1}0..$W]}0..$H;
my($Z,$d,$t,@J,@C,@p,@q,@r,@s)=(0);
map{$Z+=$_}@{$_}for@N;die'Nets must have 6 faces'unless$Z==6;
## To help with cube finding!!!!!

## Find the boundary points - we can use this for the toroidal calculation....
for$t(1..$h){for(1..$w){next if' 'eq$M[$t][$_];$p[$t]=$_;$r[$t]||=$_;$q[$_]=$t;$s[$_]||=$t}}
my@K=j();
say "XX",@{$_} for @M;
## Generate jump maps for the two "folds" of the map - when you jum off into space where do you go...
## @J is for the toroidal map - and just rotates to the other side
## @C is for the cube map - and requires a fold map is generated {hand crafted above}

for$t(1..$h){my$r=int(($t-1)/$S);
  for(1..$w){next unless'.'eq$M[$t][$_];my$c=int(($_-1)/$S);
    for$d(0..3){warn "$d @{$D[$d]}";warn "(",$M[ $t+$D[$d][1]][$_+$D[$d][0]],")";next if$M[ $t+$D[$d][1]][$_+$D[$d][0]]ne' ';
warn"$t,$_,$d|$r,$c|";
      my$q=$d==0?[$t,$r[$t],$d]:$d==1?[$s[$_],$_,$d]:$d==2?[$t,$p[$t],$d]:$d==3?[$q[$_],$_,$d]:-1;
      $J[$d]{$_}{$t}=$M[$q->[0]][$q->[1]] eq '#' ? undef : $q;
## Cubic map
      my($j,$k,$l)=@{$K[$r][$c][$d]};
      my$P=$d==0?$t-$r*$S-1:$d==1?($c+1)*$S-$_:$d==2?($r+1)*$S-$t:$_-$c*$S-1;
      my($p,$z)=$l==0?($j*$S+1+$P,$k*$S+1):$l==1?($j*$S+1,($k+1)*$S-$P):$l==2?(($j+1)*$S-$P,($k+1)*$S):(($j+1)*$S,$k*$S+1+$P);
      $C[$d]{$_}{$t}=$M[$p][$z]eq'#'?undef:[$p,$z,$l,$P]}}}


## Follow path using jump maps....

for$t(\@J,\@C){my($r,$c,$d)=(1,$r[1],0);
for(@P){'R'eq$_?($d++,$d%=4):'L'eq$_?($d--,$d%=4):map{exists$t->[$d]{$c}{$r}?
  defined$t->[$d]{$c}{$r}?($r,$c,$d)=@{$t->[$d]{$c}{$r}}:next:
  $M[$r+$D[$d][1]][$c+$D[$d][0]]eq'.'?($r+=$D[$d][1],$c+=$D[$d][0]):next
}1..$_}push@R,$r*1e3+$c*4+$d}

say"Time :",sprintf'%0.6f',time-$time;say for@R;

sub n{my($p,$q)=@_;for my$y(0..$H){
  say join'',map{($p->[$y][$_]?($q->[$y][$_][0]//'X').'--'.($q->[$y][$_][1]//'X'):'')}0..$W;
  say join'',map{($p->[$y][$_]?'||':'')}0..$W;
  say join'',map{($p->[$y][$_]?($q->[$y][$_][3]//'X').'--'.($q->[$y][$_][2]//'X'):'')}0..$W
}say''}

sub j{
  my($z,$f,$c,$x,$v,@V,@Z,$d,$e)=({},0,1,0,12,map{[map{$_?[qw(. . . .)]:[]}@{$_}]}@N);
  if($H>1){O:for(0..$H-2){for$x(0..$W){
    ($f,$V[$_][$x],$V[$_+1][$x],$V[$_+2][$x])=(1,[qw(A B D C)],[qw(C D F E)],[qw(E F H G)]),last O if $N[$_][$x] && $N[$_+1][$x] && $N[$_+2][$x]}}}
  if($W>1&&!$f){P:for$x(0..$W-2){for(0..$H){
    ($f,$V[$_][$x],$V[$_][$x+1],$V[$_][$x+2])=(1,[qw(A B F E)],[qw(B C G F)],[qw(C D H G)]),last P if $N[$_][$x] && $N[$_][$x+1] && $N[$_][$x+2]}}}
  if($H&&$W&&!$f){R:for$x(0..$W-1){for(1..$H-1){if($N[$_][$x]&&$N[$_][$x+1]){
    ($f,$v,$V[$_-1][$x+1],$V[$_][$x],$V[$_][$x+1],$V[$_+1][$x])=(1,8,[qw(A G C B)],[qw(A B E D)],[qw(B C F E)],[qw(D E F H)]), last R if $N[$_-1][$x+1] && $N[$_+1][$x];
    ($f,$v,$V[$_-1][$x],$V[$_][$x],$V[$_][$x+1],$V[$_+1][$x+1])=(1,8,[qw(G C B A)],[qw(A B E D)],[qw(B C F E)],[qw(E F H D)]), last R if $N[$_-1][$x] && $N[$_+1][$x+1]}}}}
  die 'Something is wrong all nets have 3 faces in a row [except for the zig/zag which has either an S or Z form' unless $f;
  while($c&&$v){$c=0;
    for$x(0..$W){for(1..$H){
      next unless$N[$_-1][$x]&&$N[$_][$x];
      $c++,$V[$_-1][$x][3]=$V[$_][$x][0]if$V[$_][$x][0]ne'.'&&$V[$_-1][$x][3]eq'.';
      $c++,$V[$_][$x][0]=$V[$_-1][$x][3]if$V[$_-1][$x][3]ne'.'&&$V[$_][$x][0]eq'.';
      $c++,$V[$_-1][$x][2]=$V[$_][$x][1]if$V[$_][$x][1]ne'.'&&$V[$_-1][$x][2]eq'.';
      $c++,$V[$_][$x][1]=$V[$_-1][$x][2]if$V[$_-1][$x][2]ne'.'&&$V[$_][$x][1]eq'.'}}
    for$x(1..$W){for(0..$H){next unless$N[$_][$x-1]&&$N[$_][$x];
      $c++,$V[$_][$x-1][1]=$V[$_][$x][0]if$V[$_][$x][0]ne'.'&&$V[$_][$x-1][1]eq'.';
      $c++,$V[$_][$x][0]=$V[$_][$x-1][1]if$V[$_][$x-1][1]ne'.'&&$V[$_][$x][0]eq'.';
      $c++,$V[$_][$x-1][2]=$V[$_][$x][3]if$V[$_][$x][3]ne'.'&&$V[$_][$x-1][2]eq'.';
      $c++,$V[$_][$x][3]=$V[$_][$x-1][2]if$V[$_][$x-1][2]ne'.'&&$V[$_][$x][3]eq'.'}}
    for$x(0..$W){for(0..$H){next unless$N[$_][$x];for$d(@G){if($V[$_][$x][$d->[0]]ne'.'&&$V[$_][$x][$d->[1]]eq'.'){
      my$F=$V[$_][$x][$d->[0]];my%f;
      for my$p(0..$W){for my$q(0..$H){next unless$N[$q][$p];for$e(@G){$f{$V[$q][$p][$e->[1]]}++if$V[$q][$p][$e->[0]]eq$F}}}
      delete$f{'.'};my$z="@{[sort values%f]}";if('1 2 2'eq$z){my($T)=grep{$f{$_}==1}keys%f;$V[$_][$x][$d->[1]]=$T;$c++}
    }}}}
  $v-=$c}
  die "Unable to resolve net - must not be a cube" if $v>0;
  for$x(0..$W){for$e(0..$H){next unless$N[$e][$x];for$d(0..3){
    push@{$z->{"@{[sort$V[$e][$x][(1+$d)%4],$V[$e][$x][(2+$d)%4]]}"}},[$e,$x,$d]}}}
  for$x(0..$W){for$e(0..$H){$Z[$e][$x]=undef,next unless$N[$e][$x];for$d(0..3){
    $Z[$e][$x][$d]=[$_->[0],$_->[1],($_->[2]-2)%4]for grep{$e!=$_->[0]&&$x!=$_->[1]}
    @{$z->{"@{[sort$V[$e][$x][(1+$d)%4],$V[$e][$x][(2+$d)%4]]}"}}}}}
print Dumper(\@Z);
  return @Z;
}

