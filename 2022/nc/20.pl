my($t,$n,$p,@z)=(0,0);
my$l=my@i=map{int$_}<>;

for([1,1],[10,811589153]){
my$c=0;
my($q,@x)=((my$m=$_->[1])%($l-1),map{[$c++,$_]}@i);
for(1..$_->[0]){for(0..$#i){$p=0;$p++while$x[$p][0]!=$_;
my$t=splice@x,$p,1;splice@x,($i[$_]*$q+$p)%($l-1),0,$t}}
$p=0;$p++while$x[$p][1];
push@z,$m*($x[($p+1e3)%$l][1]+$x[($p+2e3)%$l][1]+$x[($p+3e3)%$l][1])}
say for @z;

