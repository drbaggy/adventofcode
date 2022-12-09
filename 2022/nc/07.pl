my $t = my $n = 0;
my( @k, %s );
open my $fh, q(<), 'data/07.txt';
  m{^(\d+)}       ? map { $s{$_}+=$1 } ('/', @k)
: m{\$ cd \.\.$}  ? pop @k
: m{\$ cd /$}     ? @k=()
: m{\$ cd (\S+)} && push @k, @k ? "$k[-1]/$1" : $1
  while <$fh>;
close $fh;
$t+=$_                   for grep { $_ <= 1e5 }           values %s;
$n = $s{'/'};
($n > $_) && ( $n = $_ ) for grep { $_ >= $s{'/'} - 4e7 } values %s;
say "Time :", sprintf '%0.6f', time-$time;
say "$t\n$n";
