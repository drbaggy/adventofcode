my@p=(['']);
my@q=(['']);
while(my $r=<>) {
last if$r!~m{\[};
my$p=0;
++$p,m{\w}&&(push@{$p[$p]},$&)&&push@{$q[$p]},$& while$_=substr$r,0,4,''
}
m{move (\d+) from (\d+) to (\d+)}&&
(unshift@{$p[$3]},reverse splice@{$p[$2]},0,$1)&&
(unshift@{$q[$3]},        splice@{$q[$2]},0,$1)while<>;
say join'',map{$_->[0]}@{$_}for\@p,\@q
