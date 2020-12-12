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
my ($x,$y,$dir,$wx,$wy);

my %act = (
  'L' => sub { ( $wx, $wy ) = $_[0] == 180 ? ( -$wx, -$wy ) : $_[0] == 270 ? ( $wy,  -$wx ) : ( -$wy,  $wx ) ; },
  'R' => sub { ( $wx, $wy ) = $_[0] == 180 ? ( -$wx, -$wy ) : $_[0] ==  90 ? ( $wy,  -$wx ) : ( -$wy,  $wx ) ; },
  'F' => sub { $x += $_[0]*$wx; $y += $_[0]*$wy; },
  'E' => sub { $wx += $_[0]; },
  'W' => sub { $wx -= $_[0]; },
  'N' => sub { $wy += $_[0]; },
  'S' => sub { $wy -= $_[0]; },
);


is( solution('test.txt'), 286 );
done_testing();

say solution();

sub solution {
  my $file_name = shift;
  # Initialize slurp variables
  ($x,$y,$dir,$wx,$wy) = (0,0,0,10,1);

  slurp_file( sub {
    return unless $_[0];
    my( $c,$n ) = $_[0] =~ m{([NSEWLRF])(\d+)};
    # Split into command and number
    $act{$c}($n);
  }, $file_name );

  return abs($x) + abs($y);
}

