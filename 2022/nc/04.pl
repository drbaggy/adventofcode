my($t,$n);
open my $fh, '<', 'data/04.txt';
m{ (\d+) - (\d+) , (\d+) - (\d+) }x,
  ( $1<=$3 && $4<=$2 || $3<=$1 && $2<=$4 ) && $t++,
    $4<$1            || $2<$3              || $n++ while <$fh>;
close $fh;
say "Time :", sprintf '%0.6f', time-$time;
say"$t\n$n";
