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

my ($x,$y,$dir);
my @D = ( [ 1, 0 ], [ 0, -1 ], [ -1, 0 ], [ 0, 1 ] ); # E,S,W,N

my %act = (
  'L' => sub { $dir -= $_[0]/90; },
  'R' => sub { $dir += $_[0]/90; },
  'F' => sub { $x += $_[0] * $D[ $dir%4 ][0];
               $y += $_[0] * $D[ $dir%4 ][1]; },
  'E' => sub { $x += $_[0]; },
  'W' => sub { $x -= $_[0]; },
  'N' => sub { $y += $_[0]; },
  'S' => sub { $y -= $_[0]; },
);

is( solution('test.txt'), 25 );
done_testing();

say solution();

sub solution {
  my $file_name = shift;
  ($x,$y,$dir) = (0,0,0);
  slurp_file( sub {
    return unless $_[0];
    my( $c, $n ) = $_[0] =~ m{([NSEWLRF])(\d+)};
    $act{$c}($n);
    # Code to process each line of input
  }, $file_name );

  return abs($x) + abs($y);
}
