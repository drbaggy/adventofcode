my($h,@g,$X,$Y,@s)=-1;
chomp,$h++,/^(.*)E/&&(($Y,$X)=($h,length$1),$s[$Y][$X]=0),tr/ES/{`/,push@g,[map{-95+ord}split//]while<>;
my($w,@q,@s,$x,$y,$l,$v,@a)=(@{$g[0]}-1,[$X,$Y,0]);
while(@q){
(($x,$y,$l)=@{shift@q}),$s[$y][$x]++&&next,$a[$v=$g[$y][$x]-1]//=$l,$l++,push@q,
($x>0&&$g[$y][$x-1]>=$v)?[$x-1,$y,$l]:(),
($x<$w&&$g[$y][$x+1]>=$v)?[$x+1,$y,$l]:(),
($y>0&&$g[$y-1][$x]>=$v)?[$x,$y-1,$l]:(),
($y<$h&&$g[$y+1][$x]>=$v)?[$x,$y+1,$l]:()
}
say for@a[0,1]
