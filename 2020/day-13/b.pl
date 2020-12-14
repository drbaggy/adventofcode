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

use AdventSupport;
## END OF BOILER PLATE;

is( solution( '7,13,x,x,59,x,31,19' ),    1068781 );
is( solution( '17,x,13,19'          ),       3417 );
is( solution( '67,7,59,61'          ),     754018 );
is( solution( '67,x,7,59,61'        ),     779210 );
is( solution( '67,7,x,59,61'        ),    1261476 );
is( solution( '1789,37,47,1889'     ), 1202161486 );

done_testing();

say solution(
 '41,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,'.
 'x,x,x,x,x,37,x,x,x,x,x,557,x,29,x,x,x,x,x,x,x,x,x,x,13,x,x,x,'.
 '17,x,x,x,x,x,23,x,x,x,x,x,x,x,419,x,x,x,x,x,x,x,x,x,x,x,x,x,x'.
 ',x,x,x,x,19'
);

sub solution {
  my ( $result, $index, $mult, @times ) = ( 0, 0, split m{,}, $_[0] );
  foreach (@times) {
    $index++;
    next if $_ eq 'x';
    $result += $mult while ($result+$index) % $_;
    $mult = lcm($mult,$_);
  }
  return $result;
}

sub lcm {
  my ($a,$b) = @_;
  ($a,$b) = ($b,$a) if $b>$a;
  my $p = $a * $b;
  ($a,$b) = ($b,$a%$b) while $b >= 1;
  return $p/$a;
}


