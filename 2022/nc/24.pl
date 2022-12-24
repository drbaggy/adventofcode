my($t,$n,@q,@G,%cache)=(0,0,[1,1,0,0]);
my@M=map{chomp;[split//]}<>;
my($R,@d)=((my$H=(@M-2))*(my$W=@{$M[0]}-2),[1,0],[0,1],[0,0],[-1,0],[0,-1]);
my($g,$h)=$H>$W?($H,$W):($W,$H);($g,$h)=($h,$g)if$h>$g;($g,$h)=($h,$g%$h)while$h;
$R/=$g;for my$l(0..$R-1){$G[$l][$_][0]=$G[$l][$_][$W+1]=1for 2..$H+1;
$G[$l][0]=[1,1,1];$G[$l][1]=[1,0,(1)x$W];$G[$l][$H+2]=[(1)x$W,0,1];
$G[$l][$H+3][$W+$_]=1 for-1..1}
for my$y(1..$H){for my$x(1..$W){
if($M[$y][$x]eq'>'){$G[$_][$y+1][($x+$_-1)%$W+1]=1for 0..$R-1}
elsif($M[$y][$x]eq'<'){$G[$_][$y+1][($x-$_-1)%$W+1]=1for 0..$R-1}
elsif($M[$y][$x]eq'^'){$G[$_][($y-$_-1)%$H+2][$x]=1for 0..$R-1}
elsif($M[$y][$x]eq'v'){$G[$_][($y+$_-1)%$H+2][$x]=1for 0..$R-1}}}
while(my$e=shift@q){my($y,$x,$T,$flag)=@{$e};next if$cache{join'-',$y,$x,(my$i=($T+1)%$R),$flag}++;
if($y<2){$flag=2if$flag==1}elsif($y>$H+1&&$flag!=1){$flag?($t=$T,last):($n||=$T,$flag=1)}
$G[$i][$y+$_->[0]][$x+$_->[1]]||push@q,[$y+$_->[0],$x+$_->[1],$T+1,$flag]for@d}
say"$n\n$t";
