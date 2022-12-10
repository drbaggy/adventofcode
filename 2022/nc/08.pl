my($n,@g)=0;
chomp,push@g,[split //]while<>;
my($h,$w)=($#g,@{$g[0]}-1);
my$t=2*($h+$w);
for my$y(1..$h-1){for my$x(1..$w-1){
my($m,$f,@s)=($g[$y][$x],0,0,0,0,0);
$s[0]++,($g[$_][$x]>=$m)&&($f|=1)&&last for reverse 0..$y-1;
$s[1]++,($g[$_][$x]>=$m)&&($f|=2)&&last for$y+1..$h;
$s[2]++,($g[$y][$_]>=$m)&&($f|=4)&&last for reverse 0..$x-1;
$s[3]++,($g[$y][$_]>=$m)&&($f|=8)&&last for$x+1..$w;
my$p=$s[0]*$s[1]*$s[2]*$s[3];
$n=$p if$n<$p;
$t++if$f!=15
}}
say"$t\n$n"
