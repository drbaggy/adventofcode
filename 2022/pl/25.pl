use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);

my($f)= __FILE__ =~ m{(\d+)[.]pl$}; die unless $f;
my $fn=__FILE__=~s/[^\/]*$//r.'../data/'.(@ARGV ? 't-'.$f : $f.'.txt');1while($fn=~s/[^\/]*\/\.\.\///);
my $time = time;

my($n,$q,$m,%R)=('',0,0,reverse my%M=qw(= -2 - -1 0 0 1 1 2 2));
open my $fh, '<', $fn;
chomp,$m=0,$q+=(map{$m=$m*5+$M{$_}}split//)[-1]for<$fh>;
close $fh;
$n=$R{$m=($q+2)%5-2}.$n,$q=($q-$m)/5while$q;

say "Time :", sprintf '%0.6f', time-$time;
say for$n,'-'
