my($t,$n,$c)=(1,0,0);
my@bps=map{[m{\d+.*?(\d+).*?(\d+).*?(\d+).*?(\d+).*?(\d+).*?(\d+)}]}<>;
$n+=P->new($_,24)->walk*++$c for@bps;
$t*=P->new($_,32)->walk for@bps[0,1,2];
say"$n\n$t";

package P;
sub ceil{int 0.99999+$_[0]}
sub new{
my($c,$z,$m)=@_;
bless{'t'=>$m||24,'b'=>0,'o'=>[@{$z}[0,1,2,4]],'r'=>[0,0,@{$z}[3,5]],
'm'=>[(sort{$b<=>$a}@{$z}[0,1,2,4])[0],@{$z}[3,5],1e6]},$c}
sub e{my$z=shift;my$s=$_[0]||{'r'=>[1,0,0,0],'u'=>[0,0,0,0],'t'=>$z->{'t'}};
my@r=@{$s->{'r'}};my@u=@{$s->{'u'}};my$time=$s->{'t'};
for my$t(3,2,1,0){next if$r[$t]>$z->{'m'}[$t]||$t&&!$r[$t-1]||
$u[3]+($r[3]*$time)+$time*($time-1)/2<=$z->{'b'};
my$p=$u[0]>$z->{'o'}[$t]?0:($z->{'o'}[$t]-$u[0])/$r[0];
my$q=$t<1?0:$u[$t-1]>$z->{'r'}[$t]?0:($z->{'r'}[$t]-$u[$t-1])/$r[$t-1];
my$r=1+ceil($p<$q?$q:$p);$r=$time if$r>$time;
my@v=map{$u[$_]+$r[$_]*$r}0..3;if($time>$r){
$v[0]-=$z->{'o'}[$t],$v[$t-1]-=$z->{'r'}[$t],my@w=@r;$w[$t]++;
$z->e({'r'=>\@w,'u'=>\@v,'t'=>$time-$r})}
$z->{'b'}=$v[3]if$v[3]>$z->{'b'}}$z->{'b'}}