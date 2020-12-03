#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);

use File::Basename qw(dirname);
use English qw(-no_match_vars $PROGRAM_NAME);
use Cwd qw(abs_path);
use Data::Dumper qw(Dumper);
use Test::More;

my $ROOT_PATH;
BEGIN { $ROOT_PATH = dirname(dirname(dirname(abs_path($PROGRAM_NAME)))); }
use lib $ROOT_PATH;
use AdventSupport;

## END OF BOILER PLATE;

is( solution('test.txt'), 7);
done_testing();

say solution();

sub solution {
  my $file_name = shift;
  # Initialize slurp variables
  my( $ROW_LENGTH, $count, $offset ) = (0,0,0);

  slurp_file( sub {
    ## Cache length of first line (and discard)
    return $ROW_LENGTH = length $_[0] unless $ROW_LENGTH;
    $count += '#' eq substr $_[0], ( $offset += 3 ) % $ROW_LENGTH, 1;
  }, $file_name );

  return $count;
}

