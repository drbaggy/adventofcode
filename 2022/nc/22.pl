my($Z,@D,@R,$S,$d,$t,@J,@C,@p,@q,@r,@s)=(0,[1,0],[0,1],[-1,0],[0,-1]);my@I=map{chomp;$_}<>;my@P=split/([LR])/,pop@I;pop@I;
my($w,@G)=(0,[0,1],[1,2],[2,3],[3,0],[1,0],[0,3],[3,2],[2,1]);length$_>$w&&($w=length$_)for@I;
my$h=(my@M=([(' ')x($w+2)],map({[@{[' ',(split//),(' ')x$w]}[0..$w+1]]}@I),[(' ')x($w+2)]))-2;
($h*$_->[0]==$w*$_->[1])&&($S=$w/$_->[0])for[3,4],[4,3],[2,5],[5,2];
my$H=$h/$S;my$W=$w/$S;my@N=map{//;[map{$M[1+$'*$S][1+$_*$S]eq' '?0:1}0..$W]}0..$H;map{$Z+=$_}@{$_}for@N;
for$t(1..$h){for(1..$w){next if' 'eq$M[$t][$_];$p[$t]=$_;$r[$t]||=$_;$q[$_]=$t;$s[$_]||=$t}}
my@K=j();for$t(1..$h){my$r=int(($t-1)/$S);for(1..$w){next if'.'ne$M[$t][$_];my$c=int(($_-1)/$S);
for$d(0..3){next if$M[$t+$D[$d][1]][$_+$D[$d][0]]ne' ';my$q=$d==0?[$t,$r[$t],$d]:$d==1?[$s[$_],$_,$d]:$d==2?[$t,$p[$t],$d]:$d==3?[$q[$_],$_,$d]:-1;
$J[$d]{$_}{$t}=$M[$q->[0]][$q->[1]]eq'#'?undef:$q;my($j,$k,$l)=@{$K[$r][$c][$d]};my$P=$d==0?$t-$r*$S-1:$d==1?($c+1)*$S-$_:$d==2?($r+1)*$S-$t:$_-$c*$S-1;
my($p,$z)=$l==0?($j*$S+1+$P,$k*$S+1):$l==1?($j*$S+1,($k+1)*$S-$P):$l==2?(($j+1)*$S-$P,($k+1)*$S):(($j+1)*$S,$k*$S+1+$P);
$C[$d]{$_}{$t}=$M[$p][$z]eq'#'?undef:[$p,$z,$l,$P]}}}
for$t(\@J,\@C){my($r,$c,$d)=(1,$r[1],0);for(@P){'R'eq$_?($d++,$d%=4):'L'eq$_?($d--,$d%=4):map{exists$t->[$d]{$c}{$r}?
defined$t->[$d]{$c}{$r}?($r,$c,$d)=@{$t->[$d]{$c}{$r}}:next:$M[$r+$D[$d][1]][$c+$D[$d][0]]eq'.'?($r+=$D[$d][1],$c+=$D[$d][0]):next}1..$_}say$r*1e3+$c*4+$d}
sub j{my($z,$f,$c,$x,$v,@V,@Z,$d,$e)=({},0,1,0,12,map{[map{$_?[qw(. . . .)]:[]}@{$_}]}@N);if($H>1){O:for(0..$H-2){for$x(0..$W){
($f,$V[$_][$x],$V[$_+1][$x],$V[$_+2][$x])=(1,[qw(A B D C)],[qw(C D F E)],[qw(E F H G)]),last O if$N[$_][$x]&&$N[$_+1][$x]&&$N[$_+2][$x]}}}
if($W>1&&!$f){P:for$x(0..$W-2){for(0..$H){
($f,$V[$_][$x],$V[$_][$x+1],$V[$_][$x+2])=(1,[qw(A B F E)],[qw(B C G F)],[qw(C D H G)]),last P if$N[$_][$x]&&$N[$_][$x+1]&&$N[$_][$x+2]}}}
if($H&&$W&&!$f){R:for$x(0..$W-1){for(1..$H-1){if($N[$_][$x]&&$N[$_][$x+1]){
($f,$v,$V[$_-1][$x+1],$V[$_][$x],$V[$_][$x+1],$V[$_+1][$x])=(1,8,[qw(A G C B)],[qw(A B E D)],[qw(B C F E)],[qw(D E F H)]),last R if$N[$_-1][$x+1]&&$N[$_+1][$x];
($f,$v,$V[$_-1][$x],$V[$_][$x],$V[$_][$x+1],$V[$_+1][$x+1])=(1,8,[qw(G C B A)],[qw(A B E D)],[qw(B C F E)],[qw(E F H D)]),last R if$N[$_-1][$x]&&$N[$_+1][$x+1]}}}}
while($c&&$v){$c=0;for$x(0..$W){for(1..$H){$N[$_-1][$x]&&$N[$_][$x]||next;
$c++,$V[$_-1][$x][3]=$V[$_][$x][0]if$V[$_][$x][0]ne'.'&&$V[$_-1][$x][3]eq'.';$c++,$V[$_][$x][0]=$V[$_-1][$x][3]if$V[$_-1][$x][3]ne'.'&&$V[$_][$x][0]eq'.';
$c++,$V[$_-1][$x][2]=$V[$_][$x][1]if$V[$_][$x][1]ne'.'&&$V[$_-1][$x][2]eq'.';$c++,$V[$_][$x][1]=$V[$_-1][$x][2]if$V[$_-1][$x][2]ne'.'&&$V[$_][$x][1]eq'.'}}
for$x(1..$W){for(0..$H){$N[$_][$x-1]&&$N[$_][$x]||next;
$c++,$V[$_][$x-1][1]=$V[$_][$x][0]if$V[$_][$x][0]ne'.'&&$V[$_][$x-1][1]eq'.';$c++,$V[$_][$x][0]=$V[$_][$x-1][1]if$V[$_][$x-1][1]ne'.'&&$V[$_][$x][0]eq'.';
$c++,$V[$_][$x-1][2]=$V[$_][$x][3]if$V[$_][$x][3]ne'.'&&$V[$_][$x-1][2]eq'.';$c++,$V[$_][$x][3]=$V[$_][$x-1][2]if$V[$_][$x-1][2]ne'.'&&$V[$_][$x][3]eq'.'}}
for$x(0..$W){for(0..$H){$N[$_][$x]||next;for$d(@G){if($V[$_][$x][$d->[0]]ne'.'&&$V[$_][$x][$d->[1]]eq'.'){my$F=$V[$_][$x][$d->[0]];my%f;
for my$p(0..$W){for my$q(0..$H){$N[$q][$p]||next;for$e(@G){$f{$V[$q][$p][$e->[1]]}++if$V[$q][$p][$e->[0]]eq$F}}}
delete$f{'.'};my$z="@{[sort values%f]}";if('1 2 2'eq$z){my($T)=grep{$f{$_}==1}keys%f;$V[$_][$x][$d->[1]]=$T;$c++}}}}}$v-=$c}
for$x(0..$W){for$e(0..$H){$N[$e][$x]||next;for$d(0..3){push@{$z->{"@{[sort$V[$e][$x][(1+$d)%4],$V[$e][$x][(2+$d)%4]]}"}},[$e,$x,$d]}}}
for$x(0..$W){for$e(0..$H){$Z[$e][$x]=undef,next if!$N[$e][$x];for$d(0..3){$Z[$e][$x][$d]=[$_->[0],$_->[1],($_->[2]-2)%4]for grep{$e!=$_->[0]&&$x!=$_->[1]}
@{$z->{"@{[sort$V[$e][$x][(1+$d)%4],$V[$e][$x][(2+$d)%4]]}"}}}}}@Z}
