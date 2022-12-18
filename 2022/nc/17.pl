my@i=map{'>'eq$_?1:-1}grep{/[<>]/}split//,<>;
my($bs,$bl,$rn,@r,@b,@h)=(511,257,0,map{my$q=$_;[map{//;[map{$_>>$'}@{$q}]}-4..3]}
[15],[4,14,4],[2,2,14],[8,8,8,8],[12,12]);
my@t=$bs;
while(1){my($x,$y,$r)=(2,0,$r[$rn++%5]);pop@t while$t[-1]==$bl;push@h,@t-1;
if($t[-1]==$bs){push@b,[$rn,- -@t];last if@b==3}my$c=@{$r->[0]}-1;
push@t,$bl for-$c..3;while(++$y){push@i,my$d=shift@i;
$x+=$d unless grep{$t[-$y-$_]&$r->[$x+$d][$_]}0..$c;
map({$t[-$y-$_]|=$r->[$x][$_]}0..$c),last if grep{$t[-$y-$_-1]&$r->[$x][$_]}0..$c;}}
my$d=$b[2][0]-$b[1][0];
for(2022,1e12){my($i,$m)=($_%$d,int($_/$d));
($i+=$d,$m--)if$i<$b[1][0];say$h[$i]+$m*($b[2][1]-$b[1][1])}
