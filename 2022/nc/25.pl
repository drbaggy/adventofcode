my($n,$q,$m,%R)=('',0,0,reverse my%M=qw(= -2 - -1 0 0 1 1 2 2));
chomp,$m=0,$q+=(map{$m=$m*5+$M{$_}}split//)[-1]for<>;
$n=$R{$m=($q+2)%5-2}.$n,$q=($q-$m)/5while$q;
say$n
