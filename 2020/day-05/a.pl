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

is( solution('test.txt'), 820 );
done_testing();

say solution();

sub solution {
  my $file_name = shift;
  # Initialize slurp variables
  my $max = 0;
  slurp_file( sub {
    my $v = unpack 'n', pack 'B16', '000000'.$_[0] =~ tr/BRFL/1100/r;
    $max = $v if $max < $v;
  }, $file_name );
  ## Now the work horse bit
  return $max;
}

