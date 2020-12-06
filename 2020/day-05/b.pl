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

#no test data...
#is( solution('test.txt'), 820 );
#done_testing();

say solution();

sub solution {
  my $file_name = shift;
  # Initialize slurp variables
  my $seats = '0' x 2000;## Should be big enough
  ## We will put a "1" in the string once we have decoded the seats
  ## We firstly convert the BFRLs into 1s and 0s and use unpack to convert this
  ## into a binary representation - which we then convert back to a number using
  ## unpack. We need to pad the string with 6 0s to make it up to an even multiple
  ## of 8 for unpack to work...
  slurp_file( sub {
    substr $seats, (unpack 'n', pack 'B16', '000000'. $_[0] =~ tr/BRFL/1100/r ), 1, '1';
  }, $file_name );
  ## The value is the position of the "1" in the seat before our seat so we have to add a "1"
  ## to the result...
  return 1+index $seats, '101';
}

