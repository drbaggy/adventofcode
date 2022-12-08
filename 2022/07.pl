use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
my $time = time;

my $t = my $n = 0;
my @keys;
my %size;

open my $fh, q(<), 'data/07.txt';
  m{^(\d+)}       ? map { $size{$_}+=$1 } ('/ROOT', @keys)
: m{\$ cd \.\.$}  ? pop @keys
: m{\$ cd /$}     ? @keys=()
: m{\$ cd (\S+)} && ( @keys ? push(@keys, $keys[-1].'/'.$1) : (@keys=($1)) )
  while <$fh>;
close $fh;

$n = $size{'/ROOT'};
($n > $_) && ( $n = $_ ) for grep { $_ >= $size{'/ROOT'} - 4e7 } values %size;
$t+=$_                   for grep { $_ <= 1e5 }                  values %size;

say "\nTime :", sprintf '%0.6f', time-$time;
say "$t\n$n";
