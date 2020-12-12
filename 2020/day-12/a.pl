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

my @D = ( [ 1, 0 ], [ 0, -1 ], [ -1, 0 ], [ 0, 1 ] ); # E,S,W,N

is( solution('test.txt'), 25 );
done_testing();

say solution();

sub solution {
  my $file_name = shift;

  my ($x,$y,$dir) = (0,0,0);

  slurp_file( sub {
    my( $c, $n ) = $_[0] =~ m{([NSEWLRF])(\d+)};
    return unless $c;
    if( $c eq 'L' ) {
      $dir -= $n / 90;
    } elsif( $c eq 'R' ) {
      $dir += $n / 90;
    } elsif( $c eq 'F' ) {
      $x += $n * $D[ $dir%4 ][ 0 ];
      $y += $n * $D[ $dir%4 ][ 1 ];
    } else {
      $x += $n if $c eq 'E';
      $x -= $n if $c eq 'W';
      $y += $n if $c eq 'N';
      $y -= $n if $c eq 'S';
    }
    # Code to process each line of input
  }, $file_name );

  return abs($x) + abs($y);
}

