my($t,$Y,$M)=(0,2e6,4e6);

my@rows=map{my@t=m{(-?\d+)}g;[@t,abs($t[0]-$t[2])+abs($t[1]-$t[3])]}<>;

my%b=map{("$_->[2]$_->[3]"=>1)}@rows;
my($l,$n)=(-1e9,-grep{$_->[1]==$Y}map{[split]}keys%b);

$_->[0]>$l?($n+=$_->[1]-$_->[0]+1,$l=$_->[1]):$_->[1]>$l&&($n+=$_->[1]-$l,$l=$_->[1])for
sort{$a->[0]<=>$b->[0]||$b->[1]<=>$a->[1]}
map{my$z=$_->[4]-abs($Y-$_->[1]);
$z<0?():[$_->[0]-$z,$_->[0]+$z]}
@rows;

my%r=map{$_->[1]+1=>1}
my@sq=map{[
$_->[0]+$_->[1]-$_->[4],$_->[0]+$_->[1]+$_->[4],
-$_->[0]+$_->[1]-$_->[4],-$_->[0]+$_->[1]+$_->[4],
]}@rows;

O:for my$X(grep{$_>0&&$_<=2*$M}keys%r){
my$B=$X>$M?2*$M-$X:$X;
my$st;
for(
map{[$_->[2],$_->[3]]}
sort{$a->[2]<=>$b->[2]||$a->[3]<=>$b->[3]}
grep{$_->[3]>=-$B||$_->[2]<=$B}
grep{$_->[0]<=$X&&$X<=$_->[1]}
@sq
){
$st||($st=$_)&&next;
if($_->[0]>$st->[1]+1){
$t=($X+$_->[0]-1)/2+2e6*($X-$_->[0]+1);
last O;
}elsif($_->[1]>$st->[1]){
$st->[1]=$_->[1];
}
}
}
say"$n\n$t";
