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
BEGIN { $ROOT_PATH = dirname(abs_path($PROGRAM_NAME)); }
use lib dirname( dirname( $ROOT_PATH ) );
use AdventSupport qw(slurp_file init);
init($ROOT_PATH);
## END OF BOILER PLATE;

is( solution('test.txt'), 7);
done_testing();

say solution();

sub solution {
  my $file_name = shift;
  # Initialize slurp variables
  my( $count,$offset ) = 0;
  slurp_file( sub {
    chomp $_[0];
    $count += '#' eq substr $_[0], $offset % length $_[0], 1;
    $offset+=3;
  }, $file_name );

  return $count;
}

