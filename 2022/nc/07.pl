my($t,@k,%s)=0;
m{^(\d+)}?map{$s{$_}+=$1}('/',@k):m{\$ cd \.\.$}?pop@k:m{\$ cd /$}?@k=():m{\$ cd (\S+)}&&push@k,@k?"$k[-1]/$1":$1 while<>;
$t+=$_ for grep{$_<=1e5}values%s;
my$N=my$n=$s{'/'};
($n>$_)&&($n=$_)for grep{$_>=$N-4e7}values%s;
say"$t\n$n"
