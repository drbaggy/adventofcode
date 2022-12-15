my($n,$t,@l)=(0,1,map{/\S/?eval$_:()}<>);
for(my $k=0;$k<@l;){$n+=(c(@l[$k++,$k++])>0)*$k;}
unshift@l,[[2]],[[6]];
my@r=sort{c( @l[$b,$a])}0..$#l;
$r[$_]<2&&($t*=($_+1))for 0..$#l;
say $n/2;
say $t;

sub c{
my($p1,$p2)=@_;
for my$c(0..@{$p1}-1){
return-1if$c>=@{$p2};
my$t=ref$p1->[$c]||ref$p2->[$c]?c(map{ref$_->[$c]?$_->[$c]:[$_->[$c]]}$p1,$p2):$p2->[$c]<=>$p1->[$c];
return$t if$t
}
@{$p1}<@{$p2}
}
