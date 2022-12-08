use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
use Data::Dumper qw(Dumper);
my $time = time;

my $t = my $n = 0;

open my $fh, q(<), 'data/07.txt';
my @keys = ('/ROOT');
my %size;
while(<$fh>) {
  if( m{^(\d+)} ) {
    $size{ $_ }+=$1 for @keys;
  } elsif( m{\$ cd (\S+)} ) {
    if($1 eq '..') {
      pop @keys if @keys > 1;
    } elsif( $1 eq '/' ) {
      @keys = ('/ROOT');
    } else {
      push @keys, $keys[-1].'/'.$1;
    }
  }
}
close $fh;

$n = $size{'/ROOT'};
($n > $_) && ( $n = $_ ) for grep { $_ >= $size{'/ROOT'} - 4e7 } values %size;
$t+=$_                   for grep { $_ <= 1e5 }                  values %size;

say "\nTime :", sprintf '%0.6f', time-$time;
say "$t\n$n";
