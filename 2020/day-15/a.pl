#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);

use File::Basename qw(dirname);
use English qw(-no_match_vars $PROGRAM_NAME);
use Cwd qw(abs_path);
use Data::Dumper qw(Dumper);
use Test::More;
use Const::Fast qw(const);

my $ROOT_PATH;
BEGIN { $ROOT_PATH = dirname(dirname(dirname(abs_path($PROGRAM_NAME)))); }
use lib $ROOT_PATH;

const my $MAX => 2020;#20;

use AdventSupport;
## END OF BOILER PLATE;

is( solution(0,3,6),  436 );
is( solution(1,3,2),    1 );
is( solution(2,1,3),   10 );
is( solution(1,2,3),   27 );
is( solution(2,3,1),   78 );
is( solution(3,2,1),  438 );
is( solution(3,1,2), 1836 );
done_testing();

say solution(17,1,3,16,19,0);

sub solution {
  my ($index,$last,@spoken) = (0);
  start_timer();
  $spoken[ $MAX+2 ] = 0;
  $last = pop @_;
  $spoken[shift @_]=$index++ while @_;
  ( $last, $spoken[$last] ) = ( exists $spoken[$last] ? $_-$spoken[$last] : 0, $_ ) foreach $index .. $MAX-2;
  say duration();
  return $last;
}

