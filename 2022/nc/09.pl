my(%v,@r)=('U'=>[0,1],'D'=>[0,-1],'R'=>[1,0],'L'=>[-1,0]);
my@l=map{/ /&&[@{$v{$`}},0+$']}<>;
for my$K(1,9){
my($h,@p)=map{[0,0]}0..$K;my%s=('0 0'=>0);
for(@l) {
my($d,$e,$l)=@{$_};
O:for(1..$l) {
$h->[0]+=$d;$h->[1]+=$e;
my$p=$h;
abs($p->[0]-$_->[0])<2&&abs($p->[1]-$_->[1])<2?next O:(
$p->[0]>$_->[0]?$_->[0]++:$p->[0]<$_->[0]&&$_->[0]--,
$p->[1]>$_->[1]?$_->[1]++:$p->[1]<$_->[1]&&$_->[1]--,
$p=$_)for@p;
$s{"@{$p}"}++
}
}
push@r,scalar values%s
}
say for @r