use Data::Dumper qw(Dumper);
my(@dir,@R)=([1,0]);push@dir,[-$dir[-1][1],$dir[-1][0]]for 1..3;
my@in=map{chomp;$_}<>;my@P=split/([LR])/,pop@in;pop@in;
my$W=0;length$_>$W&&($W=length$_)for@in;
my$H=(my@M=([(' ')x($W+2)],map({[@{[' ',(split//),(' ')x$W]}[0..($W+1)]]}@in),[(' ')x($W+2)]))-2;
my$Z=$H*3==$W*4?$W/3:$H*4==$W*3?$H/3:$H*5==$W*2?$W/5:$H/5;
my(@J,@C,@mx_x,@mx_y,@mn_x,@mn_y);
for my$r(1..$H){for my$c(1..$W){next if$M[$r][$c]eq' ';
$mx_x[$r]=$c;$mn_x[$r]||=$c;$mx_y[$c]=$r;$mn_y[$c]||=$r}}
my@cj=([undef,[undef,undef,[2,0,0],[3,0,0]],[[2,1,2],[1,1,2],undef,[3,0,3]]],
[undef,[[0,2,3],undef,[2,0,1],undef],undef],
[[undef,undef,[0,1,0],[1,1,0]],[[0,2,2],[3,0,2],undef,undef],undef],
[[[2,1,3],[0,2,1],[0,1,1],undef],undef,undef]);
for my$r(1..$H){my$fr=int(($r-1)/$Z);for my$c(1..$W){next unless$M[$r][$c]eq'.';
my$fc=int(($c-1)/$Z);for my$d(0..3){next if$M[$r+$dir[$d][1]][$c+$dir[$d][0]]ne' ';
my$dest=$d==0?[$r,$mn_x[$r],$d]:$d==1?[$mn_y[$c],$c,$d]:$d==2?[$r,$mx_x[$r],$d]:$d==3?[$mx_y[$c],$c,$d]:-1;
$J[$d]{$c}{$r}=$M[$dest->[0]][$dest->[1]]eq'#'?undef:$dest;
my($dr,$dc,$dd)=@{$cj[$fr][$fc][$d]};my$pos=$d==0?$r-$fr*$Z-1:$d==1?($fc+1)*$Z-$c:$d==2?($fr+1)*$Z-$r:$c-$fc*$Z-1;
my($nr,$nc)=$dd==0?($dr*$Z+1+$pos,$dc*$Z+1):$dd==1?($dr*$Z+1,($dc+1)*$Z-$pos):$dd==2?(($dr+1)*$Z-$pos,($dc+1)*$Z):(($dr+1)*$Z,$dc*$Z+1+$pos);
$C[$d]{$c}{$r}=$M[$nr][$nc]eq'#'?undef:[$nr,$nc,$dd,$pos]}}}
for my$K(\@J,\@C){my($r,$c,$d)=(1,$mn_x[1],0);for(@P){'R'eq$_?($d++,$d%=4):'L'eq$_?($d--,$d%=4):
map{exists$K->[$d]{$c}{$r}?defined$K->[$d]{$c}{$r}?($r,$c,$d)=@{$K->[$d]{$c}{$r}}:next:$M[$r+$dir[$d][1]][$c+$dir[$d][0]]eq'.'?($r+=$dir[$d][1],$c+=$dir[$d][0]):next}1..$_}
push@R,$r*1000+$c*4+$d}
say for@R;
