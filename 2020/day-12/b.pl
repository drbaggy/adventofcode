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

is( solution('test.txt'), 286 );
done_testing();

say solution();

sub solution {
  my $file_name = shift;
  # Initialize slurp variables
  my ($x,$y,$dir,$wx,$wy) = (0,0,0,10,1);

  slurp_file( sub {
    my( $c,$n ) = $_[0] =~ m{([NSEWLRF])(\d+)};
    return unless $c;
    # Split into command and number
    if( $c eq 'L' || $c eq 'R' ) { ## Rotate way point
      $n = 360 - $n if $c eq 'L';
      ( $wx, $wy ) = ( -$wx, -$wy ) if $n == 180;
      ( $wx, $wy ) = ( $wy,  -$wx ) if $n ==  90;
      ( $wx, $wy ) = ( -$wy,  $wx ) if $n == 270;
    } elsif( $c eq 'F' ) { ## Move ship
      $x += $n * $wx;
      $y += $n * $wy;
    } else { ## Move waypoint
      $wx += $n if $c eq 'E';
      $wx -= $n if $c eq 'W';
      $wy += $n if $c eq 'N';
      $wy -= $n if $c eq 'S';
    }
  }, $file_name );

  return abs($x) + abs($y);
}

