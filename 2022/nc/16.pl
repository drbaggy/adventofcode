my($i,$t,@v,@map,%ix,@nd,%mp,%ch)=(0,0);
while(<>){m{ (\w+).*=(\d+).*valves? (.*)};
$mp{$1}{$_}=$mp{$_}{$1}=1 for split/, /,$3;
if($2>0||$1eq'AA'){my$s=$ix{$1}||=$1 eq'AA'?0:++$i;
$v[$s]=$2;$map[$s]=$1;$nd[$s][$s]=0}}
d($_,$map[$_],0,'')for 0..$i;
z();
my$n=w(30,0,0,0,0..$i);
my@K=sort{$ch{$b}<=>$ch{$a}||$a<=>$b}keys%ch;
while(my$k=shift@K){last if(my$p=$ch{$k})*2<=$t;
$p+$ch{$_}<=$t?last:$k&$_||($t=$ch{$_}+$p)for@K}
say"$n\n$t";
sub w{my($ht,$pt,$pr,$pr2,$x,@n)=@_;my$p=$pr;for(1..@n){
my$y=shift@n;my$h=$ht-$nd[$x][$y]-1;if($h>0){if($h<5){
my$v=w($h,$pt,$pr+$h*$v[$y],$pr2,$y,@n);$p=$v if$v>$p}else{
my($p2,$np2)=($pt|1<<$y,$pr2+($h-4)*$v[$y]);$ch{$p2}=$np2
unless exists$ch{$p2}&&$np2<=$ch{$p2};my$v=w($h,$p2,$pr+$h*$v[$y],$np2,$y,@n);
$p=$v if$v>$p}}push@n,$y}$p}
sub d{my($r,$c,$l,$p)=@_;if($l&&exists$ix{$c}){
$nd[$r][$ix{$c}]= $nd[$ix{$c}][$r]=$l
unless $nd[$ix{$c}][$r]&&$nd[$ix{$c}][$r]>$l;
return}d($r,$_,$l+1,$c)for grep{$_ ne$p}keys%{$mp{$c}}}
sub z{for my$x(0..$i){my$u=1;while($u){$u=0;for my$y(0..$i){
next if$x==$y||!$nd[$x][$y];for(0..$i) {next if$_==$y||$_==$x||!$nd[$y][$_];
my$t=$nd[$x][$y]+$nd[$y][$_];($nd[$x][$_],$u)=($t,1)
unless$nd[$x][$_]&&$nd[$x][$_]<=$t}}}}}
